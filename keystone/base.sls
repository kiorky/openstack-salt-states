{% import "openstack/config.sls" as config with context %}

keystone:
    user:
        - present
    group:
        - present

/etc/keystone/keystone.conf:
    file.managed:
        - source: salt://openstack/keystone/keystone.conf
        - user: keystone
        - group: keystone
        - mode: 0600
        - template: jinja
        - context:
            port: {{ config.keystone_port }}
            auth: {{ config.keystone_auth }}
            token: {{ config.keystone_token }}
            public_ip: {{ config.public_ip }}
            debug: {{ config.debug }}
            mysql_username: {{ config.mysql_keystone_username }}
            mysql_password: {{ config.mysql_keystone_password }}
            mysql_host: {{ config.mysql_hosts[0] }}
            mysql_database: {{ config.mysql_keystone_database }}
            compute_port: {{ config.compute_port }}
    require:
        - user: keystone
        - group: keystone

/etc/keystone/policy.json:
    file.managed:
        - source: salt://openstack/keystone/policy.json
        - user: keystone
        - group: keystone
        - mode: 0600
    require:
        - user: keystone
        - group: keystone

/etc/keystone/init.sh:
    file.managed:
        - source: salt://openstack/keystone/init.sh
        - user: keystone
        - group: keystone
        - mode: 0700
        - template: jinja
        - context:
            port: {{ config.keystone_port }}
            auth: {{ config.keystone_auth }}
            token: {{ config.keystone_token }}
            username: {{ config.os_username }}
            password: {{ config.os_password }}
            tenant: {{ config.os_tenant_name }}
            service_tenant: {{ config.service_tenant_name }}
            nova_username: nova
            nova_password: {{ config.keystone_nova_password }}
            glance_username: glance
            glance_password: {{ config.keystone_glance_password }}
            cinder_username: cinder
            cinder_password: {{ config.keystone_cinder_password }}
            public_ip: {{ config.public_ip }}
            nova_ip: {{ config.nova_api_hosts|first }}
            glance_ip: {{ config.glance_hosts|first }}
            cinder_ip : {{ config.cinder_api_hosts|first }}
            nova_api_port: {{ config.compute_port }}
            glance_api_port: {{ config.glance_api_port }}
            cinder_api_port: {{ config.volume_port }}
    require:
        - user: keystone
        - group: keystone
