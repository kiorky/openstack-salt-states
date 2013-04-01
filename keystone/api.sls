include:
    - openstack.keystone.base

keystone:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/keystone/keystone.conf
            - file: /etc/keystone/policy.json
            - pkg: keystone

{{ salt['data.update']('openstack.keystone', salt['network.ip_addrs'](interface='', include_loopback=False)) }}
