include:
    - openstack.glance

'/etc/glance/api-paste.ini':
    file.managed:
        - source: salt://openstack/glance/api-paste.ini
        - user: glance
        - group: glance
        - mode: 0600
        - template: mako

glance-api:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/glance/glance.conf
            - file: /etc/glance/policy.json
            - file: /etc/glance/api-paste.ini
            - pkg: glance-api
