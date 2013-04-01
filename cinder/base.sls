include:
    - openstack.config

cinder:
    - user.present
    - group.present

'/etc/cinder/cinder.conf':
    file.managed:
        - source: salt://openstack/cinder/cinder.conf
        - user: cinder
        - group: cinder
        - mode: 0600
        - template: mako

'/etc/cinder/policy.json':
    file.managed:
        - source: salt://openstack/cinder/policy.json
        - user: cinder
        - group: cinder
        - mode: 0600
        - template: mako
