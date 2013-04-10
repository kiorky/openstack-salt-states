{% import "openstack/config.sls" as config with context %}
include:
    - openstack.nova.base

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
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
            - file: /etc/nova/api-paste.ini
    require:
        - pkg: nova-api
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
        - file: /etc/nova/api-paste.ini

{{ config.package("nova-objectstore") }}
    service.running:
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
        - enable: True
        - watch:
            - pkg: nova-cert
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
    require:
        - pkg: nova-cert
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json

{% set res = salt['data.update']('openstack.nova.api', config.public_ip) %}
