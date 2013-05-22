{% import "openstack/config.sls" as config with context %}
include:
    - openstack.quantum.base

{{ config.package("quantum-l3-agent") }}
    service.running:
        - name: quantum-l3-agent
        - enable: True
        - watch:
            - pkg: quantum-l3-agent
            - file: /etc/quantum/quantum.conf
    require:
        - pkg: quantum-l3-agent
        - file: /etc/quantum/quantum.conf
