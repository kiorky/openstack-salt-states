{% import "openstack/config.sls" as config with context %}
include:
    - base

/etc/nova/api-paste.ini:
    file.managed:
        - source: salt://openstack/nova/api-paste.ini
        - user: nova
        - group: nova
        - mode: 0600
    require:
        - user: nova
        - group: nova

{{ config.package("nova-api") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-api
    require:
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
        - file: /etc/nova/api-paste.ini

{{ config.package("nova-objectstore") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-objectstore
    require:
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json

{{ config.package("nova-novncproxy") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-novncproxy
    require:
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json

{{ config.package("nova-consoleauth") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-consoleauth
    require:
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json

{{ config.package("nova-cert") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-cert
    require:
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json

{% set res = salt['data.update']('openstack.nova.api', config.public_ip) %}
