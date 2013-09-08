{% import "openstack/config.sls" as config with context %}
include:
    - openstack.nova.base

/etc/init/nova-conductor.conf:
    file.managed:
        - source: salt://openstack/nova/nova-conductor.conf
        - user: root
        - group: root
        - mode: 0644

/etc/init/nova-conductor-all.conf:
    file.managed:
        - source: salt://openstack/nova/nova-conductor-all.conf
        - user: root
        - group: root
        - mode: 0644

{{ config.package("nova-conductor") }}
    service.running:
        - name: nova-conductor-all
        - enable: True
        - watch:
            - pkg: nova-conductor
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
            - file: /etc/init/nova-conductor.conf
            - file: /etc/init/nova-conductor-all.conf
        - require:
            - pkg: nova-conductor
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
            - file: /etc/init/nova-conductor.conf
            - file: /etc/init/nova-conductor-all.conf
