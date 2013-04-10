{% import "openstack/config.sls" as config with context %}
include:
    - openstack.nova.base

{{ config.package("nova-scheduler") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-scheduler
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
    require:
        - pkg: nova-scheduler
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
