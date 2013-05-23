{% import "openstack/config.sls" as config with context %}
include:
    - openstack.quantum.base
    - openstack.quantum.ovs

{{ config.package("quantum-plugin-openvswitch-agent") }}
    service.running:
        - name: quantum-plugin-openvswitch-agent
        - enable: True
        - watch:
            - pkg: quantum-plugin-openvswitch-agent
            - file: /etc/quantum/quantum.conf
            - file: /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini
    require:
        - pkg: quantum-plugin-openvswitch-agent
        - file: /etc/quantum/quantum.conf
        - file: /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini
