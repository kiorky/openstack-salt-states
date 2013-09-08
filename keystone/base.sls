{% import "openstack/config.sls" as config with context %}
keystone:
  pkg.installed:
    - names:
      - python-memcache
      - keystone
  user.present:
    - groups: ['keystone', 'openstack']
  group.present: []

/etc/keystone/keystone.conf:
  file.managed:
    - source: salt://openstack/keystone/keystone.conf
    - user: keystone
    - group: keystone
    - mode: 0600
    - template: jinja
    - context:
      port: {{ config.keystone_port }}
      auth: {{ config.keystone_auth }}
      token: {{ config.keystone_token }}
      ip: {{ config.public_ip }}
      debug: {{ config.debug }}
      mysql_username: {{ config.mysql_keystone_username }}
      mysql_password: {{ config.mysql_keystone_password }}
      mysql_host: {{ config.mysql_hosts[0] }}
      mysql_database: {{ config.mysql_keystone_database }}
      compute_port: {{ config.compute_port }}
  require:
    - user: keystone
    - group: keystone

/etc/keystone/policy.json:
  file.managed:
    - source: salt://openstack/keystone/policy.json
    - user: keystone
    - group: keystone
    - mode: 0600
  require:
    - user: keystone
    - group: keystone

