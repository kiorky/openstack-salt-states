include:
    - openstack.cinder.base

'/etc/cinder/api-paste.ini':
    file.managed:
        - source: salt://openstack/cinder/api-paste.ini
        - user: cinder
        - group: cinder
        - mode: 0600
        - template: mako

cinder-api:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/cinder/cinder.conf
            - file: /etc/cinder/policy.json
            - file: /etc/cinder/api-paste.ini
            - pkg: cinder-api
