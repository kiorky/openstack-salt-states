{% import "openstack/config.sls" as config with context %}
{% set keystone_hosts = salt['publish.publish']('D@openstack.keystone:*', 'data.getval', 'openstack.keystone', expr_form='compound').values() %}

/etc/openstack-dashboard/local_settings.py:
    file.managed:
        - source: salt://openstack/horizon/local_settings.py
        - user: root
        - group: root
        - mode: 0600
        - template: jinja
        - context:
            debug: {{config.debug}}
            keystone_host: {{config.keystone_hosts}}
            keystone_port: {{config.keystone_port}}
            mysql_host: {{config.mysql_hosts}}
            mysql_database: {{config.mysql_horizon_database}}
            mysql_username: {{config.mysql_horizon_username}}
            mysql_password: {{config.mysql_horizon_password}}

{{ config.package("openstack-dashboard") }}
    require:
        - file: /etc/openstack-dashboard/local_settings.py
