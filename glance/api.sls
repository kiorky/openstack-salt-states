{% import "openstack/config.sls" as config with context %}
include:
    - base

/etc/glance/glance-api-paste.ini:
    file.managed:
        - source: salt://openstack/glance/glance-api-paste.ini
        - user: glance
        - group: glance
        - mode: 0600
    require:
        - user: glance
        - group: glance

{{ config.package("glance-api") }}
    service.running:
        - enable: True
        - watch:
            - file: /etc/glance/policy.json
            - file: /etc/glance/glance-api-paste.ini
            - pkg: glance-api
    require:
        - file: /etc/glance/policy.json
        - file: /etc/glance/glance-api-paste.ini
