include:
    - openstack.nova.base

nova-novncproxy:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
            - pkg: nova-novncproxy
