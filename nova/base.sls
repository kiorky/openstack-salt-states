{% import "openstack/config.sls" as config %}

nova:
    - user.present
    - group.present
  
/etc/nova/nova.conf:
    file.managed:
        - source: salt://openstack/nova/nova.conf
        - user: nova
        - group: nova
        - mode: 0600
    require:
        - user: nova
        - group: nova

/etc/nova/policy.json:
    file.managed:
        - source: salt://openstack/nova/policy.json
        - user: nova
        - group: nova
        - mode: 0600
    require:
        - user: nova
        - group: nova
