include:
    - openstack.cinder.base

cinder-scheduler:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/cinder/cinder.conf
            - file: /etc/cinder/policy.json
            - pkg: cinder-scheduler
