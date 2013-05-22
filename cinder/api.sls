{% import "openstack/config.sls" as config with context %}
include:
    - openstack.cinder.base

/etc/cinder/api-paste.ini:
    file.managed:
        - source: salt://openstack/cinder/api-paste.ini
        - user: cinder
        - group: cinder
        - mode: 0600
        - mode: 0600
        - template: jinja
        - context:
            debug: {{ config.debug }}
            mysql_username: {{ config.mysql_cinder_username }}
            mysql_password: {{ config.mysql_cinder_password }}
            mysql_database: {{ config.mysql_cinder_database }}
            mysql_host: {{ config.mysql_hosts|first }}
            keystone_ip: {{ config.keystone_hosts|first }}
            keystone_port: {{ config.keystone_port }}
            keystone_auth: {{ config.keystone_auth }}
            cinder_tenant_name: {{ config.service_tenant_name }}
            cinder_username: cinder
            cinder_password: {{ config.keystone_cinder_password }}
    require:
        - user: cinder
        - group: cinder

{{ config.package("cinder-api") }}
    service.running:
        - name: cinder-api
        - enable: True
        - watch:
            - pkg: cinder-api
            - file: /etc/cinder/cinder.conf
            - file: /etc/cinder/policy.json
            - file: /etc/cinder/api-paste.ini
    require:
        - pkg: cinder-api
        - file: /etc/cinder/cinder.conf
        - file: /etc/cinder/policy.json
        - file: /etc/cinder/api-paste.ini
