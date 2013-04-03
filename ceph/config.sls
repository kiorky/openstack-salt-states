{% import "openstack/config.sls" as config with context %}

{% set source = pillar.get('openstack:ceph:source', 'deb http://ceph.com/debian precise main') %}
{% set ip = config.internal_ip %}
{% set devices = pillar.get('openstack:ceph:devices', {}) %}
