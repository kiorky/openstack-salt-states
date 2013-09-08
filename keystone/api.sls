{% import "openstack/config.sls" as config with context %}
include:
    - openstack.env
    - openstack.keystone.base

{{ config.package("memcached") }}
    service.running:
        - name: memcached
        - enable: True

{{ config.package("keystone") }}
    service.running:
        - name: keystone
        - enable: True
        - watch:
            - pkg: keystone
            - file: /etc/keystone/keystone.conf
            - file: /etc/keystone/policy.json
            - file: /etc/keystone/init.sh
    require:
        - service: memcached
        - file: /etc/keystone/keystone.conf
        - file: /etc/keystone/policy.json

{{ config.keystone_cmd(
    'keystone-create-db',
      'keystone-manage db_sync',
      unless='keystone user-list ') }}

{% for i in [
  'init.sh',
  'init-keystone.sh',

] %}
#  'init-nova.sh',
#  'init-cinder.sh',
#  'init-glance.sh',
#  'init-quantum.sh',
{% set service_name=i.replace('init-', '').replace('.sh', '') %}
/etc/keystone/{{i}}:
  file.managed:
    - source: salt://openstack/keystone/{{i}}
    - user: keystone
    - group: keystone
    - mode: 0700
    - template: jinja
    {{- config.os_context_var() }}
      service_name: {{service_name}}
  require:
    - file: /etc/openstack/openstack.env
    - user: keystone
    - group: keystone

{% if i != 'init.sh' %}
run-{{i}}:
  cmd.run:
    - name: /etc/keystone/{{i}}
    - stateful: True
  require:
    - file: /etc/openstack
    - file: /etc/keystone/{{i}}
    - cmd: keystone-create-db
    {% if i != 'init-keystone.sh' -%}
    - cmd: run-init-keystone.sh{% endif %}

env-{{i}}:
  file.directory:
    - name: /etc/openstack/openstack.env.d/
    - file_mode: 0770
    - recurse: [user, group, mode]
    - user: openstack
    - group: openstack
  require:
    - cmd: run-{{i}}

{% endif %}
{% endfor %}
