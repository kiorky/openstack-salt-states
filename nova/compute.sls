{% import "openstack/config.sls" as config with context %}
include:
    - openstack.nova.api

{{ config.package("nova-compute") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-compute
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
    require:
        - service: nova-api
        - pkg: nova-compute
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
