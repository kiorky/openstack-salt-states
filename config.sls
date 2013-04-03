{% set debug = pillar.get('openstack:debug', 'True') %}
{% set source = pillar.get('openstack:source', 'deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main') %}

# Packaging.
{% macro package(name) %}
ubuntu-cloud-keyring:
    pkg:
        - latest
{{name}}:
    pkg:
        - latest
    pkgrepo.managed:
        - name: {{source}}
        - baseurl: {{source}}
        - humanname: openstack
        - file: /etc/apt/sources.list.d/openstack.list
    require:
        - pkgrepo: {{source}}
        - pkg: ubuntu-cloud-keyring
{% endmacro %}

# Network configuration.
{% set default_interface = pillar.get('openstack:interfaces:default', 'eth0') %}
{% set internal_interface = pillar.get('openstack:interfaces:internal', default_interface) %}
{% set nova_interface = pillar.get('openstack:interfaces:nova', default_interface) %}
{% set public_interface = pillar.get('openstack:interfaces:public', default_interface) %}

# Network auto-computed.
{% set internal_ip = salt['network.ip_addrs'](interface=internal_interface)|first %}
{% set nova_ip = salt['network.ip_addrs'](interface=nova_interface)|first %}
{% set public_ip = salt['network.ip_addrs'](interface=public_interface)|first %}

# Database configuration.
{% set mysql_keystone_database = pillar.get('openstack:keystone:database', 'keystone') %}
{% set mysql_keystone_username = pillar.get('openstack:keystone:username', 'keystone') %}
{% set mysql_keystone_password = pillar.get('openstack:keystone:password', '') %}

{% set mysql_nova_database = pillar.get('openstack:nova:database', 'nova') %}
{% set mysql_nova_username = pillar.get('openstack:nova:username', 'nova') %}
{% set mysql_nova_password = pillar.get('openstack:nova:password', '') %}

{% set mysql_glance_database = pillar.get('openstack:glance:database', 'glance') %}
{% set mysql_glance_username = pillar.get('openstack:glance:username', 'glance') %}
{% set mysql_glance_password = pillar.get('openstack:glance:password', '') %}

{% set mysql_cinder_database = pillar.get('openstack:cinder:database', 'cinder') %}
{% set mysql_cinder_username = pillar.get('openstack:cinder:username', 'cinder') %}
{% set mysql_cinder_password = pillar.get('openstack:cinder:password', '') %}

{% set mysql_horizon_database = pillar.get('openstack:horizon:database', 'horizon') %}
{% set mysql_horizon_username = pillar.get('openstack:horizon:username', 'horizon') %}
{% set mysql_horizon_password = pillar.get('openstack:horizon:password', '') %}

{% set mysql_quantum_database = pillar.get('openstack:quantum:database', 'quantum') %}
{% set mysql_quantum_username = pillar.get('openstack:quantum:username', 'quantum') %}
{% set mysql_quantum_password = pillar.get('openstack:quantum:password', '') %}

{% set os_username = pillar.get('openstack:admin:username', 'admin') %}
{% set os_password = pillar.get('openstack:admin:password', 'admin') %}
{% set os_tenant_name = pillar.get('openstack:admin:tenant_name', 'admin') %}

# Rabbit configuration.
{% set rabbitmq_user = pillar.get('openstack:rabbit:user', 'guest') %}
{% set rabbitmq_password = pillar.get('openstack:rabbit:password', 'guest') %}
{% set rabbitmq_vhost = pillar.get('openstack:rabbit:vhost', '/') %}

# Keystone configuration.
{% set keystone_port = pillar.get('openstack:keystone:port', '5000') %}
{% set keystone_auth = pillar.get('openstack:keystone:auth', '35357') %}
{% set keystone_token = pillar.get('openstack:keystone:token', '') %}

# API configuration.
{% set compute_port = pillar.get('openstack:api:compute', '8774') %}
{% set glance_api_port = pillar.get('openstack:api:glance', '9292') %}
{% set glance_registry_port = pillar.get('openstack:api:glance', '9191') %}

# Keystone services.
{% set service_tenant_name = pillar.get('openstack:service:tenant_name', 'service') %}
{% set nova_username = pillar.get('openstack:nova:username', 'nova') %}
{% set nova_password = pillar.get('openstack:nova:password', '') %}
{% set glance_username = pillar.get('openstack:glance:username', 'glance') %}
{% set glance_password = pillar.get('openstack:glance:password', '') %}
