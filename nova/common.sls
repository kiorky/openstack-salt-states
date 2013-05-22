{% import "openstack/config.sls" as config with context %}
include:
    - openstack.nova.base

{{ config.package("nova-api") }}
    service.running:
        - name: nova-api
        - enable: True
        - watch:
            - pkg: nova-api
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
            - file: /etc/nova/api-paste.ini
    require:
        - pkg: nova-api
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
        - file: /etc/nova/api-paste.ini

