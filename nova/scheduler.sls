{% import "openstack/config.sls" as config with context %}
include:
    - base

{{ config.package("nova-scheduler") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-scheduler
    require:
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
