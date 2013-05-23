{% import "openstack/config.sls" as config with context %}

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
            glance_host: {{ config.glance_hosts|first }}
            glance_port: {{ config.glance_api_port }}
            keystone_host: {{ config.keystone_hosts|first }}
            keystone_port: {{ config.keystone_port }}
            mysql_username: {{ config.mysql_nova_username }}
            mysql_password: {{ config.mysql_nova_password }}
            mysql_host: {{ config.mysql_hosts|first }}
            mysql_database: {{ config.mysql_nova_database }}
            internal_ip: {{ config.internal_ip }}
            rabbit_host: {{ config.rabbitmq_hosts|first }}
            rabbit_user: {{ config.rabbitmq_user }}
            rabbit_password: {{ config.rabbitmq_password }}
            novnc_host: {{ config.novnc_hosts|first }}
            public_ip: {{ config.public_ip }}
            az: {{ config.az }}
            default_az: {{ config.default_az }}
            metadata_secret: {{ config.metadata_secret }}
            network_port: {{ config.network_port }}
            keystone_host: {{ config.keystone_hosts|first }}
            keystone_auth: {{ config.keystone_auth }}
            quantum_host: {{ config.quantum_api_hosts|first }}
            quantum_tenant_name: {{ config.service_tenant_name }}
            quantum_username: quantum
            quantum_password: {{ config.keystone_quantum_password }}
{% if config.vms_key %}
            cobalt: True
{% else %}
            cobalt: False
{% endif %}
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

/etc/nova/api-paste.ini:
    file.managed:
        - source: salt://openstack/nova/api-paste.ini
        - user: nova
        - group: nova
        - mode: 0600
        - template: jinja
        - context:
            keystone_host: {{ config.keystone_hosts|first }}
            keystone_auth: {{ config.keystone_auth }}
            nova_tenant_name: {{ config.service_tenant_name }}
            nova_username: nova
            nova_password: {{ config.keystone_nova_password }}
    require:
        - user: nova
        - group: nova
