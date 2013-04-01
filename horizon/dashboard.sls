include:
    - openstack.horizon.base

apache2:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - pkg: openstack-dashboard
