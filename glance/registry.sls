{% import "openstack/config.sls" as config with context %}
include:
    - openstack.glance.base

/etc/glance/glance-registry-paste.ini:
    file.managed:
        - source: salt://openstack/glance/glance-registry-paste.ini
        - user: glance
        - group: glance
        - mode: 0600
        - template: jinja
        - context:
            debug: {{ config.debug }}
            port: {{ config.glance_registry_port }}
            mysql_username: {{ config.mysql_glance_username }}
            mysql_password: {{ config.mysql_glance_password }}
            mysql_database: {{ config.mysql_glance_database }}
            mysql_host: {{ config.mysql_hosts|first }}
            keystone_ip: {{ config.keystone_hosts|first }}
            keystone_port: {{ config.keystone_port }}
            keystone_auth: {{ config.keystone_auth }}
            glance_tenant_name: {{ config.service_tenant_name }}
            glance_username: glance
            glance_password: {{ config.keystone_glance_password }}
    require:
        - user: glance
        - group: glance

/etc/glance/glance-registry.conf:
    file.managed:
        - source: salt://openstack/glance/glance-registry.conf
        - user: glance
        - group: glance
        - mode: 0600
        - context:
            debug: {{ config.debug }}
            port: {{ config.glance_registry_port }}
            mysql_username: {{ config.mysql_glance_username }}
            mysql_password: {{ config.mysql_glance_password }}
            mysql_database: {{ config.mysql_glance_database }}
            mysql_host: {{ config.mysql_hosts|first }}
            keystone_ip: {{ config.keystone_hosts|first }}
            keystone_port: {{ config.keystone_port }}
            keystone_auth: {{ config.keystone_auth }}
            glance_tenant_name: {{ config.service_tenant_name }}
            glance_username: glance
            glance_password: {{ config.keystone_glance_password }}
    require:
        - user: glance
        - group: glance

{{ config.package("glance-registry") }}
    service.running:
        - name: glance-registry
        - enable: True
        - watch:
            - pkg: glance-registry
            - file: /etc/glance/policy.json
            - file: /etc/glance/glance-registry-paste.ini
            - file: /etc/glance/glance-registry.conf
    require:
        - file: /etc/glance/policy.json
        - file: /etc/glance/glance-registry-paste.ini
        - file: /etc/glance/glance-registry.conf
