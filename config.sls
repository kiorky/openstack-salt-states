{% set openstack = pillar.get('openstack', {}) %}
{% set debug = openstack.get('debug', 'True') %}
{% set version = openstack.get('version', 'grizzly') %}
{% set source = openstack.get('source', 'deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/%s main' % version) %}

{% import_yaml "openstack/glance/images.sls" as default_glance_images %}
{% set glance_images=openstack.get('glance-images', False) %}
{% if glance_images == False %}
  {% set glance_images=default_glance_images.images %}
{% endif %}

# Packaging.
# NOTE: This goes hand-in-hand with the source listed above.
# For the time being, these recipes only support Ubuntu precise w/
# cloud archive -- although it would be a straight-forward path to
# support other distributions.
{% macro package(name) %}
keyring-{{name}}:
    pkg:
        - installed
        - name: ubuntu-cloud-keyring
pkg-{{name}}-uptodate:
    pkg:
        - latest
        - name: {{name}}
    require:
        - pkg: pkg-{{name}}
pkg-{{name}}:
    pkg:
        - installed
        - name: {{name}}
    pkgrepo.managed:
        - name: {{source}}
        - baseurl: {{source}}
        - humanname: openstack
        - file: /etc/apt/sources.list.d/openstack-{{version}}.list
    require:
        - pkgrepo: {{source}}
        - pkg: ubuntu-cloud-keyring
{% endmacro %}

# Network configuration.
{% set interfaces = openstack.get('interfaces', {}) %}
{% set networks = openstack.get('networks', {}) %}
{% set public_network = networks.get('public') %}
{% set internal_network = networks.get('internal') %}

# Common services configuration.
{% set az = openstack.get('availability_zone', 'nova') %}
{% set default_az = openstack.get('default_availability_zone', 'nova') %}

# Ugly network IP extraction (automatic based on subnet from config).
{% set _pre_cmd = "python -c 'from salt.modules.network import interfaces, _calculate_subnet; addresses=[]; map(addresses.extend, [itr.get(\"inet\") for itr in interfaces().values() if itr.get(\"inet\")]); subnets=\"" %}
{% set _post_cmd = "\".split(\",\"); matches=[addr.get(\"address\") for addr in addresses if _calculate_subnet(addr.get(\"address\"), addr.get(\"netmask\")) in subnets]; matches.append(\"0.0.0.0\"); print matches[0];'" %}
{% set internal_ip = openstack.get('internal_ip') %}
{% if not internal_ip %}
{% set internal_ip = salt['cmd.run'](_pre_cmd + internal_network + _post_cmd) %}
{% endif %}

{% set public_ip = openstack.get('public_ip') %}
{% if not public_ip %}
{% set public_ip = salt['cmd.run'](_pre_cmd + public_network + _post_cmd) %}
{% endif %}

# Database configuration.
{% set keystone = openstack.get('keystone', {}) %}
{% set mysql_keystone_database = keystone.get('database', 'keystone') %}
{% set mysql_keystone_username = keystone.get('username', 'keystone') %}
{% set mysql_keystone_password = keystone.get('password', 'keystone') %}

{% set nova = openstack.get('nova', {}) %}
{% set mysql_nova_database = nova.get('database', 'nova') %}
{% set mysql_nova_username = nova.get('username', 'nova') %}
{% set mysql_nova_password = nova.get('password', 'nova') %}
{% set metadata_secret = nova.get('metadata_secret', 'password') %}

{% set glance = openstack.get('glance', {}) %}
{% set mysql_glance_database = glance.get('database', 'glance') %}
{% set mysql_glance_username = glance.get('username', 'glance') %}
{% set mysql_glance_password = glance.get('password', 'glance') %}
{% set glance_store = glance.get('store', 'filesystem') %}

{% set cinder = openstack.get('cinder', {}) %}
{% set mysql_cinder_database = cinder.get('database', 'cinder') %}
{% set mysql_cinder_username = cinder.get('username', 'cinder') %}
{% set mysql_cinder_password = cinder.get('password', 'cinder') %}

{% set quantum = openstack.get('quantum', {}) %}
{% set mysql_quantum_database = quantum.get('database', 'quantum') %}
{% set mysql_quantum_username = quantum.get('username', 'quantum') %}
{% set mysql_quantum_password = quantum.get('password', 'quantum') %}

{% set horizon = openstack.get('horizon', {}) %}
{% set mysql_horizon_database = horizon.get('database', 'horizon') %}
{% set mysql_horizon_username = horizon.get('username', 'horizon') %}
{% set mysql_horizon_password = horizon.get('password', 'horizon') %}

{% set admin = openstack.get('admin', {}) %}
{% set os_username = admin.get('username', 'admin') %}
{% set os_password = admin.get('password', 'admin') %}
{% set os_tenant_name = admin.get('tenant_name', 'admin') %}

# Rabbit configuration.
{% set rabbit = openstack.get('rabbit', {}) %}
{% set rabbitmq_user = rabbit.get('user', 'guest') %}
{% set rabbitmq_password = rabbit.get('password', 'guest') %}
{% set rabbitmq_vhost = rabbit.get('vhost', '/') %}

# Keystone configuration.
{% set keystone_port = keystone.get('port', '5000') %}
{% set keystone_auth = keystone.get('auth', '35357') %}
{% set keystone_token = keystone.get('token', 'keystone') %}
{% set keystone_region = keystone.get('region', 'RegionOne') %}

# API configuration.
{% set api = openstack.get('api', {}) %}
{% set ec2_port = api.get('ec2', '8773') %}
{% set compute_port = api.get('compute', '8774') %}
{% set volume_port = api.get('volume', '8776') %}
{% set network_port = api.get('volume', '9696') %}
{% set glance_api_port = glance.get('api', '9292') %}
{% set glance_registry_port = glance.get('registry', '9191') %}
{% set glance_download_path = glance.get('download_path', '/root/glance_images') %}

# Keystone services.
{% set project_tenant = openstack.get('project_tenant', 'demo') %}
{% set project_user = openstack.get('project_user', 'demo') %}
{% set project_password = openstack.get('project_password', 'demo') %}
{% set service_tenant_name = keystone.get('tenant_name', 'service') %}
{% set keystone_nova_password = keystone.get('nova', mysql_nova_password) %}
{% set keystone_glance_password = keystone.get('glance', mysql_glance_password) %}
{% set keystone_glance_username = keystone.get('glance', 'glance') %}
{% set keystone_cinder_password = keystone.get('cinder', mysql_cinder_password) %}
{% set keystone_quantum_password = keystone.get('quantum', mysql_quantum_password) %}

# VMS configuration.
{% set vms_key = openstack.get('vms') %}
{% macro vms(name) %}
{% if vms_key %}
{% set vms_cobalt = 'deb http://downloads.gridcentriclabs.com/packages/cobalt/%s/ubuntu/ gridcentric multiverse' % version %}
{% set vms_cobaltclient = 'deb http://downloads.gridcentriclabs.com/packages/cobaltclient/%s/ubuntu/ gridcentric multiverse' % version %}
{% set vms_priv = 'deb http://downloads.gridcentriclabs.com/packages/%s/vms/ubuntu/ gridcentric multiverse' % vms_key %}
vms-repo-cobalt-{{name}}:
    pkgrepo.managed:
        - name: {{vms_cobalt}}
        - baseurl: {{vms_cobalt}}
        - humanname: gridcentric
        - file: /etc/apt/sources.list.d/gridcentric.list
    cmd.run:
        - name: wget -O - http://downloads.gridcentriclabs.com/packages/gridcentric.key | sudo apt-key add -
        - unless: sudo apt-key list | grep gridcentric
vms-repo-cobaltclient-{{name}}:
    pkgrepo.managed:
        - name: {{vms_cobaltclient}}
        - baseurl: {{vms_cobaltclient}}
        - humanname: gridcentric
        - file: /etc/apt/sources.list.d/gridcentric.list
    cmd.run:
        - name: wget -O - http://downloads.gridcentriclabs.com/packages/gridcentric.key | sudo apt-key add -
        - unless: sudo apt-key list | grep gridcentric
vms-repo-priv-{{name}}:
    pkgrepo.managed:
        - name: {{vms_priv}}
        - baseurl: {{vms_priv}}
        - file: /etc/apt/sources.list.d/gridcentric.list
    cmd.run:
        - name: wget -O - http://downloads.gridcentriclabs.com/packages/gridcentric.key | sudo apt-key add -
        - unless: sudo apt-key list | grep gridcentric
vms-pkg-{{name}}-uptodate:
    pkg:
        - latest
        - name: {{name}}
    require:
        - pkg: vms-pkg-{{name}}
vms-pkg-{{name}}:
    pkg:
        - installed
        - name: {{name}}
    require:
        - pkgrepo: vms-repo-pub-{{name}}
        - pkgrepo: vms-repo-priv-{{name}}
{% endif %}
{% endmacro %}

# Debug output.
echo-internal:
    cmd.run:
        - name: echo internal "{{ internal_ip }}"
echo-public:
    cmd.run:
        - name: echo public "{{ public_ip }}"

{% set hosts = openstack.get('hosts', {}) %}
{% set mysql_hosts = hosts.get('mysql', [internal_ip]) %}
{% set rabbitmq_hosts = hosts.get('rabbitmq', [internal_ip]) %}
{% set nova_api_hosts = hosts.get('nova', [public_ip]) %}
{% set cinder_api_hosts = hosts.get('cinder', [public_ip]) %}
{% set quantum_api_hosts = hosts.get('quantum', [public_ip]) %}
{% set keystone_hosts = hosts.get('keystone', [public_ip]) %}
{% set glance_hosts = hosts.get('glance', [public_ip]) %}
{% set novnc_hosts = hosts.get('novnc', [internal_ip]) %}
{% macro os_env() %}
    - env:
      - OS_AUTH_URL: http://{{keystone_hosts|first}}:{{keystone_auth}}/v2.0
      - OS_USERNAME:  {{ os_username }}
      - OS_TENANT_NAME: {{os_tenant_name}}
      - OS_PASSWORD: {{os_password}}
      - OS_REGION_NAME: {{keystone_region}}{% endmacro %}
{% macro os_init_env() %}
    - env:
      - SERVICE_TOKEN: {{ keystone_token }}
      - SERVICE_ENDPOINT: http://{{keystone_hosts|first}}:{{keystone_auth}}/v2.0{% endmacro %}
{% macro glance_cmd(name, cmd, unless='', requires=None) %}
{% if not requires %}{% set requires=[] %}{% endif -%}
{% set dummy=requires.append('service: glance-api') %}
{{ name }}:
  cmd.run:
    - name: {{ cmd -}}
    {{ os_env() }}
    {%- if unless %}
    - unless: {{ unless }}
    {% endif %}
  require:
    {% for r in requires -%}
    - {{r}}
    {% endfor -%}
{% endmacro %}
{% macro keystone_cmd(name, cmd, unless='') %}
{{ name }}:
  cmd.run:
    - name: {{ cmd -}}
    {{ os_init_env() }}
    {%- if unless %}
    - unless: {{ unless }}
    {%- endif %}
  require:
    - service: keystone
{% endmacro %}
{% macro os_context_var() %}
    - context:
      auth: {{ keystone_auth }}
      project_tenant: {{ project_tenant }}
      project_user: {{ project_user }}
      project_password: {{ project_password }}
      username: {{ os_username }}
      cinder_api_port: {{ volume_port }}
      cinder_ip: {{ cinder_api_hosts|first }}
      cinder_ips: {{ cinder_api_hosts }}
      cinder_password: {{ keystone_cinder_password }}
      cinder_username: cinder
      glance_api_port: {{ glance_api_port }}
      glance_ip: {{ glance_hosts|first }}
      glance_ips: {{ glance_hosts }}
      glance_username: {{ keystone_glance_username }}
      glance_password: {{ keystone_glance_password }}
      keystone_ip: {{ keystone_hosts|first }}
      keystone_region: {{ keystone_region }}
      keystone_ips: {{ keystone_hosts }}
      mysql_database: {{ mysql_keystone_database }}
      mysql_host: {{ mysql_hosts[0] }}
      mysql_password: {{ mysql_keystone_password }}
      mysql_username: {{ mysql_keystone_username }}
      nova_api_port: {{ compute_port }}
      nova_ip: {{ nova_api_hosts|first }}
      nova_ips: {{ nova_api_hosts }}
      nova_password: {{ keystone_nova_password }}
      nova_username: nova
      password: {{ os_password }}
      port: {{ keystone_port }}
      quantum_api_port: {{ network_port }}
      quantum_ip: {{ quantum_api_hosts|first }}
      quantum_ips: {{ quantum_api_hosts }}
      quantum_password: {{ keystone_quantum_password }}
      quantum_username: quantum
      service_tenant: {{ service_tenant_name }}
      tenant: {{ os_tenant_name }}
      token: {{ keystone_token }}
      {% endmacro %}

