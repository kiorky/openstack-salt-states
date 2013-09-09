{% import "openstack/config.sls" as config with context %}
include:
    - openstack.glance.base
    - openstack.env

/etc/glance/glance-api-paste.ini:
    file.managed:
        - source: salt://openstack/glance/glance-api-paste.ini
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

/etc/glance/glance-api.conf:
    file.managed:
        - source: salt://openstack/glance/glance-api.conf
        - user: glance
        - group: glance
        - mode: 0600
        - template: jinja
        - context:
            debug: {{ config.debug }}
            port: {{ config.glance_api_port }}
            mysql_username: {{ config.mysql_glance_username }}
            mysql_password: {{ config.mysql_glance_password }}
            mysql_database: {{ config.mysql_glance_database }}
            mysql_host: {{ config.mysql_hosts|first }}
            rabbit_host: {{ config.rabbitmq_hosts|first }}
            rabbit_user: {{ config.rabbitmq_user }}
            rabbit_password: {{ config.rabbitmq_password }}
            rabbit_vhost: {{ config.rabbitmq_vhost }}
            keystone_ip: {{ config.keystone_hosts|first }}
            keystone_port: {{ config.keystone_port }}
            keystone_auth: {{ config.keystone_auth }}
            glance_store: {{ config.glance_store }}
            glance_tenant_name: {{ config.service_tenant_name }}
            glance_username: {{ config.keystone_glance_username }}
            glance_password: {{ config.keystone_glance_password }}
            registry_host: {{ config.glance_hosts|first }}
            registry_port: {{ config.glance_registry_port }}
            ip: {{ config.public_ip }}
    require:
        - user: glance
        - group: glance

{{ config.package("glance-api") }}
    service.running:
        - name: glance-api
        - enable: True
        - watch:
            - pkg: glance-api
            - file: /etc/glance/policy.json
            - file: /etc/glance/glance-api-paste.ini
            - file: /etc/glance/glance-api.conf
    require:
        - file: /etc/glance/policy.json
        - file: /etc/glance/glance-api-paste.ini
        - file: /etc/glance/glance-api.conf

{{ config.glance_cmd(
    'glance-create-db',
    'glance-manage db_sync',
    unless='glance image-list') }}

