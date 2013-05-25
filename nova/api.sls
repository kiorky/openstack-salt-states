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
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
        - file: /etc/nova/api-paste.ini

{{ config.vms("cobalt-api") }}
{% if config.vms_key %}
    require:
        - pkg: nova-api
    watch:
        - pkg: nova-api
{% endif %}

{{ config.package("nova-objectstore") }}
    service.running:
        - name: nova-objectstore
        - enable: True
        - watch:
            - pkg: nova-objectstore
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
    require:
        - pkg: nova-objectstore
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json

{{ config.package("nova-novncproxy") }}
    service.running:
        - name: nova-novncproxy
        - enable: True
        - watch:
            - pkg: nova-novncproxy
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
    require:
        - pkg: nova-novncproxy
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json

{{ config.package("nova-consoleauth") }}
    service.running:
        - name: nova-consoleauth
        - enable: True
        - watch:
            - pkg: nova-consoleauth
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
    require:
        - pkg: nova-consoleauth
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json

{{ config.package("nova-cert") }}
    service.running:
        - name: nova-cert
        - enable: True
        - watch:
            - pkg: nova-cert
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
    require:
        - pkg: nova-cert
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
