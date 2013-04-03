{% include "openstack/glance/api.sls" %}
{% include "openstack/glance/registry.sls" %}
{% include "openstack/nova/api.sls" %}
{% include "openstack/nova/scheduler.sls" %}
{% include "openstack/cinder/api.sls" %}
{% include "openstack/cinder/scheduler.sls" %}
{% include "openstack/keystone/api.sls" %}
