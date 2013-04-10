{% import "openstack/config.sls" as config with context %}
{% set mysql_hosts = salt['publish.publish']('D@openstack.mysql:*', 'data.getval', 'openstack.mysql', expr_form='compound').values() %}
{% set rabbitmq_hosts = salt['publish.publish']('D@openstack.rabbitmq:*', 'data.getval', 'openstack.rabbitmq', expr_form='compound').values() %}
{% set keystone_hosts = salt['publish.publish']('D@openstack.keystone:*', 'data.getval', 'openstack.keystone', expr_form='compound').values() %}
{% set glance_api_hosts = salt['publish.publish']('D@openstack.glance.api:*', 'data.getval', 'openstack.glance.api', expr_form='compound').values() %}

nova:
    user:
        - present
    group:
        - present
  
/etc/nova/nova.conf:
    file.managed:
        - source: salt://openstack/nova/nova.conf
        - user: nova
        - group: nova
        - mode: 0600
        - template: jinja
        - context:
            debug: {{ config.debug }}
            ec2_port: {{ config.ec2_port }}
            compute_port: {{ config.compute_port }}
            fixed: {{ config.nova }}
            glance_host: {{ glance_api_hosts|first }}
            glance_port: {{ config.glance_api_port }}
            keystone_host: {{ keystone_hosts|first }}
            keystone_port: {{ config.keystone_port }}
            mysql_username: {{ config.mysql_nova_username }}
            mysql_password: {{ config.mysql_nova_password }}
            mysql_host: {{ mysql_hosts|first }}
            mysql_database: {{ config.mysql_nova_database }}
            nova_interface: {{ config.nova_interface }}
            nova_ip: {{ config.nova_ip }}
            internal_ip: {{ config.internal_ip }}
            public_interface: {{ config.public_interface }}
            public_cidr: {{ config.public_network }}
            fixed_cidr: {{ config.nova_network }}
            rabbit_host: {{ rabbitmq_hosts|first }}
            rabbit_user: {{ config.rabbitmq_user }}
            rabbit_password: {{ config.rabbitmq_password }}
    require:
        - user: nova
        - group: nova

/etc/nova/policy.json:
    file.managed:
        - source: salt://openstack/nova/policy.json
        - user: nova
        - group: nova
        - mode: 0600
    require:
        - user: nova
        - group: nova
