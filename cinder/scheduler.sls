{% import "openstack/config.sls" as config with context %}
include:
    - base

{{ config.package("cinder-scheduler") }}
    service.running:
        - enable: True
        - watch:
            - pkg: cinder-scheduler
    require:
        - file: /etc/cinder/cinder.conf
        - file: /etc/cinder/policy.json
