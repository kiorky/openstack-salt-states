{% import "openstack/config.sls" as config with context %}

rabbitmq-server:
    pkg:
        - installed
    service:
        - running
    require:
        - pkg.installed: rabbitmq-server
    watch:
        - pkg.installed: rabbitmq-server

rabbitmq:
    rabbitmq_user.present:
        - name: {{ config.rabbitmq_user }}
        - password: {{ config.rabbitmq_password }}
        - force: True
    rabbitmq_vhost.present:
        - name: {{ config.rabbitmq_vhost }}
        - user: {{ config.rabbitmq_user }}
        - conf: .*
        - write: .*
        - read: .*
    require:
        - service: rabbitmq-server
