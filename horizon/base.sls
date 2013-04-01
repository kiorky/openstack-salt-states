#!mako|yaml

include:
    - openstack.config

'/etc/openstack-dashboard/local_settings.py':
    file.managed:
        - source: salt://openstack/horizon/local_settings.py
        - user: root
        - group: root
        - mode: 0600
        - template: mako
        - context:
            - debug: "{{ debug }}"
            - keystone_host: "{{ keystone_host }}"
            - keystone_port: "{{ keystone_port }}"
            - mysql_host: "{{ mysql_hosts[0] }}"
            - mysql_database: "{{ mysql_horizon_database }}"
            - mysql_username: "{{ mysql_horizon_username }}"
            - mysql_password: "{{ mysql_horizon_password }}"
