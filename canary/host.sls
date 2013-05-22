{% import "openstack/canary/config.sls" as config with context %}
include:
    - openstack.nova.base

{{ config.package("canary-host") }}
    service.running:
        - name: canary
        - enable: True
        - watch:
            - pkg: canary-host
            - file: /etc/nova/nova.conf
    require:
        - service: canary
