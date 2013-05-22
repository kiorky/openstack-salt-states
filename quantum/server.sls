{% import "openstack/config.sls" as config with context %}
include:
    - openstack.quantum.base
    - openstack.quantum.ovs

/etc/quantum/api-paste.ini:
    file.managed:
        - source: salt://openstack/quantum/api-paste.ini
        - user: quantum
        - group: quantum
        - mode: 0600
        - mode: 0600
        - template: jinja
        - context:
            keystone_ip: {{ config.keystone_hosts|first }}
            keystone_port: {{ config.keystone_port }}
            keystone_auth: {{ config.keystone_auth }}
            quantum_tenant_name: {{ config.service_tenant_name }}
            quantum_username: quantum
            quantum_password: {{ config.keystone_quantum_password }}
    require:
        - user: quantum
        - group: quantum

{{ config.package("quantum-plugin-openvswitch") }}
    require:
        - pkg: quantum-server

{{ config.package("quantum-server") }}
    service.running:
        - name: quantum-server
        - enable: True
        - watch:
            - pkg: quantum-server
            - pkg: quantum-plugin-openvswitch
            - file: /etc/quantum/quantum.conf
            - file: /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini
    require:
        - pkg: quantum-dhcp-agent
        - file: /etc/quantum/quantum.conf
        - file: /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini
