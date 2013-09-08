{% import "openstack/config.sls" as config with context %}
include:
    - openstack.quantum.base

/etc/quantum/dhcp_agent.ini:
    file.managed:
        - source: salt://openstack/quantum/dhcp_agent.ini
        - user: quantum
        - group: quantum
        - mode: 0600
        - template: jinja
        - context:
            keystone_ip: {{ config.keystone_hosts|first }}
            keystone_port: {{ config.keystone_port }}
            keystone_auth: {{ config.keystone_auth }}
            quantum_tenant_name: {{ config.service_tenant_name }}
            quantum_username: quantum
            quantum_password: {{ config.keystone_quantum_password }}
            metadata_ip: {{ config.nova_api_hosts|first }}
            metadata_secret: {{ config.metadata_secret }}

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
