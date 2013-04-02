{% import "openstack/config.sls" as config %}

keystone:
    - user.present
    - group.present

/etc/keystone/keystone.conf:
    file.managed:
        - source: salt://openstack/keystone/keystone.conf
        - user: keystone
        - group: keystone
        - mode: 0600
    require:
        - user: keystone
        - group: keystone

/etc/keystone/policy.json:
    file.managed:
        - source: salt://openstack/keystone/policy.json
        - user: keystone
        - group: keystone
        - mode: 0600
    require:
        - user: keystone
        - group: keystone
