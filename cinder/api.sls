{% import "openstack/config.sls" as config with context %}
include:
    - base

/etc/cinder/api-paste.ini:
    file.managed:
        - source: salt://openstack/cinder/api-paste.ini
        - user: cinder
        - group: cinder
        - mode: 0600
    require:
        - user: cinder
        - group: cinder

{{ config.package("cinder-api") }}
    service.running:
        - enable: True
        - watch:
            - pkg: cinder-api
    require:
        - file: /etc/cinder/cinder.conf
        - file: /etc/cinder/policy.json
        - file: /etc/cinder/api-paste.ini

{% set res = salt['data.update']('openstack.cinder.api', config.public_ip) %}
