{% import "openstack/config.sls" as config with context %}
{% set mysql_hosts = salt['publish.publish']('D@openstack.mysql:*', 'data.getval', 'openstack.mysql', expr_form='compound').values() %}
{% set keystone_hosts = salt['publish.publish']('D@openstack.keystone:*', 'data.getval', 'openstack.keystone', expr_form='compound').values() %}
{% set glance_registry_hosts = salt['publish.publish']('D@openstack.glance.registry:*', 'data.getval', 'openstack.glance.registry', expr_form='compound').values() %}

include:
    - openstack.ceph
    - openstack.glance.base

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
            glance_username: {{ config.glance_username }}
            glance_password: {{ config.glance_password }}
    require:
        - user: glance
        - group: glance

/etc/glance/glance-api.conf:
    file.managed:
        - source: salt://openstack/glance/glance-api.conf
        - user: glance
        - group: glance
        - mode: 0600
        - context:
            - debug: {{ config.debug }}
            - port: {{ config.glance_api_port }}
            - mysql_username: {{ config.mysql_glance_username }}
            - mysql_password: {{ config.mysql_glance_password }}
            - mysql_database: {{ config.mysql_glance_database }}
            - mysql_host: {{ mysql_hosts|first }}
            - rabbit_host: {{ rabbitmq_hosts|first }}
            - rabbit_userid={{rabbit_user}}
            - rabbit_password={{rabbit_password}}
            - rabbit_virtual_host={{rabbit_vhost}}
            - keystone_ip: {{ keystone_hosts|first }}
            - keystone_port: {{ config.keystone_port }}
            - keystone_auth: {{ config.keystone_auth }}
            - glance_tenant_name: {{ config.service_tenant_name }}
            - glance_username: {{ config.glance_username }}
            - glance_password: {{ config.glance_password }}
            - registry_host={{registry_ip}}
            - registry_port={{registry_port}}
    require:
        - user: glance
        - group: glance

{{ config.package("glance-api") }}
    service.running:
        - enable: True
        - watch:
            - pkg: glance-api
    require:
        - file: /etc/glance/policy.json
        - file: /etc/glance/glance-api-paste.ini
        - file: /etc/glance/glance-api.conf

make-images:
    cmd.run:
        - name: rados mkpool images
    require:
        - file: /etc/ceph/ceph.conf

{% set res = salt['data.update']('openstack.glance.api', config.public_ip) %}
