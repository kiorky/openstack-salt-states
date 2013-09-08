{% import "openstack/config.sls" as config with context %}

openstack:
  user.present:
    - groups: ['openstack']
    - require:
      - group: openstack
  group.present: []

/etc/openstack:
  file.recurse:
    - source: salt://openstack/env
    - user: openstack
    - group: openstack
    - file_mode: 0770
    - dirmode: 0770
    - template: jinja
    {{- config.os_context_var() }}
  require:
    - user: openstack
    - group: openstack
