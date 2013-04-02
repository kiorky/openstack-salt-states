{% include "openstack/control/mysql.sls" %}
{% include "openstack/control/rabbitmq.sls" %}
{% include "openstack/glance/registry.sls" %}
{% include "openstack/nova/scheduler.sls" %}
{% include "openstack/cinder/scheduler.sls" %}
