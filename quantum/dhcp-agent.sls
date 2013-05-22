{% import "openstack/config.sls" as config with context %}
include:
    - openstack.quantum.base

/etc/quantum/dhcp_agent.ini:
    file.managed:
        - source: salt://openstack/quantum/dhcp_agent.ini
        - user: quantum
        - group: quantum
        - mode: 0600

{{ config.package("quantum-dhcp-agent") }}
    service.running:
        - name: quantum-dhcp-agent
        - enable: True
        - watch:
            - pkg: quantum-dhcp-agent
            - file: /etc/quantum/quantum.conf
            - file: /etc/quantum/dhcp_agent.ini
    require:
        - pkg: quantum-dhcp-agent
        - file: /etc/quantum/quantum.conf
        - file: /etc/quantum/dhcp_agent.ini
