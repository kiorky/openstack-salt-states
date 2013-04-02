{% import "openstack/config.sls" as config with context %}
include:
    - base

{{ config.package("nova-network") }}
    service.running:
        - enable: True
        - watch:
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
            - pkg: nova-network
    require:
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
