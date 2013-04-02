{% import "openstack/config.sls" as config with context %}

glance:
    - user.present
    - group.present

/etc/glance/policy.json:
    file.managed:
        - source: salt://openstack/glance/policy.json
        - user: glance
        - group: glance
        - mode: 0600
    require:
        - user: glance
        - group: glance
