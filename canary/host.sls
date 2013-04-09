{% import "openstack/canary/config.sls" as config with context %}

{{ config.package("canary-host") }}
    service.running:
        - name: canary
        - enable: True
        - watch:
            - pkg: canary-host
    require:
        - service: canary
