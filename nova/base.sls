{% import "openstack/config.sls" as config with context %}
{% set rabbitmq_hosts = salt['publish.publish']('D@openstack.rabbitmq:*', 'data.getval', 'openstack.rabbitmq', expr_form='compound', timeout=1).values() %}
{% set glance_api_hosts = salt['publish.publish']('D@openstack.glance.api:*', 'data.getval', 'openstack.glance.api', expr_form='compound', timeout=1).values() %}

nova:
    user:
        - present
    group:
        - present
  
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
