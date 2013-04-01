include:
    - openstack.nova.base
    - openstack.nova.objectstore
    - openstack.nova.novncproxy
    - openstack.nova.consoleauth
    - openstack.nova.cert

'/etc/nova/api-paste.ini':
    file.managed:
        - source: salt://openstack/nova/api-paste.ini
        - user: nova
        - group: nova
        - mode: 0600
        - template: mako

nova-api:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
            - file: /etc/nova/api-paste.ini
            - pkg: nova-api
