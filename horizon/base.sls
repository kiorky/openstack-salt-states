{% import "openstack/config.sls" as config with context %}

/etc/openstack-dashboard/local_settings.py:
    file.managed:
        - source: salt://openstack/horizon/local_settings.py
        - user: root
        - group: root
        - mode: 0600
        - template: jinja
        - context:
            debug: {{config.debug}}
            keystone_host: {{ config.keystone_hosts|first }}
            keystone_port: {{ config.keystone_port }}
            mysql_host: {{ config.mysql_hosts|first }}
            mysql_database: {{ config.mysql_horizon_database }}
            mysql_username: {{ config.mysql_horizon_username }}
            mysql_password: {{ config.mysql_horizon_password }}
{% if config.vms_key %}
            cobalt: True
{% else %}
            cobalt: False
{% endif %}

{{ config.package("openstack-dashboard") }}
    require:
        - file: /etc/openstack-dashboard/local_settings.py

{{ config.vms("cobalt-horizon") }}
{% if config.vms_key %}
    require:
        - pkg: openstack-dashboard
    watch:
        - pkg: openstack-dashboard
{% endif %}
