{% import "openstack/config.sls" as config with context %}

quantum:
    user:
        - present
    group:
        - present

/etc/quantum/quantum.conf:
    file.managed:
        - source: salt://openstack/quantum/quantum.conf
        - user: quantum
        - group: quantum
        - mode: 0600
        - template: jinja
        - context:
            debug: {{ config.debug }}
            rabbit_user: {{ config.rabbitmq_user }}
            rabbit_password: {{ config.rabbitmq_user }}
            rabbit_host: {{ config.rabbitmq_hosts|first }}
            mysql_username: {{ config.mysql_quantum_username }}
            mysql_password: {{ config.mysql_quantum_password }}
            mysql_database: {{ config.mysql_quantum_database }}
            mysql_host: {{ config.mysql_hosts|first }}
            public_ip: {{ config.public_ip }}
            network_port: {{ config.network_port }}
            keystone_host: {{ config.keystone_hosts|first }}
            keystone_auth: {{ config.keystone_auth }}
            quantum_tenant_name: {{ config.service_tenant_name }}
            quantum_username: quantum
            quantum_password: {{ config.keystone_quantum_password }}
    require:
        - user: quantum
        - group: quantum

/etc/sudoers.d/quantum_sudoers:
    file.managed:
        - source: salt://openstack/quantum/quantum_sudoers
        - user: root
        - group: root
        - mode: 0440

/etc/quantum/policy.json:
    file.managed:
        - source: salt://openstack/quantum/policy.json
        - user: quantum
        - group: quantum
        - mode: 0600
    require:
        - user: quantum
        - group: quantum
