{% import "openstack/config.sls" as config with context %}
{% set mysql_hosts = salt['publish.publish']('D@openstack.mysql:*', 'data.getval', 'openstack.mysql', expr_form='compound').values() %}
{% set rabbitmq_hosts = salt['publish.publish']('D@openstack.rabbitmq:*', 'data.getval', 'openstack.rabbitmq', expr_form='compound').values() %}
{% set keystone_hosts = salt['publish.publish']('D@openstack.keystone:*', 'data.getval', 'openstack.keystone', expr_form='compound').values() %}
{% set glance_api_hosts = salt['publish.publish']('D@openstack.glance.api:*', 'data.getval', 'openstack.glance.api', expr_form='compound').values() %}

cinder:
    user:
        - present
    group:
        - present

/etc/cinder/cinder.conf:
    file.managed:
        - source: salt://openstack/cinder/cinder.conf
        - user: cinder
        - group: cinder
        - mode: 0600
        - template: jinja
        - context:
            debug: {{ config.debug }}
            rabbit_user: {{ config.rabbitmq_user }}
            rabbit_password: {{ config.rabbitmq_user }}
            rabbit_host: {{ rabbitmq_hosts|first }}
            mysql_username: {{ config.mysql_cinder_username }}
            mysql_password: {{ config.mysql_cinder_password }}
            mysql_database: {{ config.mysql_cinder_database }}
            mysql_host: {{ mysql_hosts|first }}
            glance_host: {{ glance_api_hosts|first }}
            glance_port: {{ config.glance_api_port }}
            ip: {{ config.internal_ip }}

/etc/cinder/policy.json:
    file.managed:
        - source: salt://openstack/cinder/policy.json
        - user: cinder
        - group: cinder
        - mode: 0600
