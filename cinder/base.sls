{% import "openstack/config.sls" as config with context %}

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
            rabbit_host: {{ config.rabbitmq_hosts|first }}
            mysql_username: {{ config.mysql_cinder_username }}
            mysql_password: {{ config.mysql_cinder_password }}
            mysql_database: {{ config.mysql_cinder_database }}
            mysql_host: {{ config.mysql_hosts|first }}
            glance_host: {{ config.glance_hosts|first }}
            glance_port: {{ config.glance_api_port }}
            ip: {{ config.internal_ip }}
            volume_port: {{ config.volume_port }}

/etc/cinder/policy.json:
    file.managed:
        - source: salt://openstack/cinder/policy.json
        - user: cinder
        - group: cinder
        - mode: 0600
