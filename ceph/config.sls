{% import "openstack/config.sls" as config with context %}
{% set ip = config.internal_ip %}

{% set ceph = pillar.get('ceph', {}) %}
{% set fsid = ceph.get('fsid', '') %}
{% set source = ceph.get('source', 'deb http://ceph.com/debian precise main') %}
{% set devices = ceph.get('devices', {}) %}
{% set auth = ceph.get('auth', {}) %}
