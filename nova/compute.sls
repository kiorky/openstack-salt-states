include:
    - openstack.nova.base
    - openstack.nova.api

nova-compute:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
            - pkg: nova-compute
