{% import "openstack/config.sls" as config with context %}
include:
    - base
    - api

{{ config.package("nova-compute") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-compute
    require:
        - service: nova-api
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
