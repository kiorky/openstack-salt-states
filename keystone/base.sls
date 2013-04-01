include:
    - openstack.config
    
'/etc/keystone/keystone.conf':
    file.managed:
        - source: salt://openstack/keystone/keystone.conf
        - user: keystone
        - group: keystone
        - mode: 0600
        - template: mako

'/etc/keystone/policy.json':
    file.managed:
        - source: salt://openstack/keystone/policy.json
        - user: keystone
        - group: keystone
        - mode: 0600
        - template: mako

keystone:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/keystone/keystone.conf
            - file: /etc/keystone/policy.json
            - pkg: keystone
