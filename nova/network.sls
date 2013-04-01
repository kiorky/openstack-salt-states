include:
    - openstack.nova.base

nova-network:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
            - pkg: nova-network
