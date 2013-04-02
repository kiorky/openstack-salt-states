{% import "openstack/config.sls" as config with context %}
include:
    - base

/etc/glance/glance-registry-paste.ini:
    file.managed:
        - source: salt://openstack/glance/glance-registry-paste.ini
        - user: glance
        - group: glance
        - mode: 0600
    required:
        - user: glance
        - group: glance

/etc/glance/glance-registry.conf:
    file.managed:
        - source: salt://openstack/glance/glance-registry.conf
        - user: glance
        - group: glance
        - mode: 0600
    require:
        - user: glance
        - group: glance

{{ config.package("glance-registry") }}
    service.running:
        - enable: True
        - watch:
            - file: /etc/glance/policy.json
            - file: /etc/glance/glance-registry-paste.ini
            - pkg: glance-api
    require:
        - file: /etc/glance/policy.json
        - file: /etc/glance/glance-registry-paste.ini
