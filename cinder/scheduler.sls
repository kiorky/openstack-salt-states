{% import "openstack/config.sls" as config with context %}
include:
    - openstack.cinder.base

{{ config.package("cinder-scheduler") }}
    service.running:
        - name: cinder-scheduler
        - enable: True
        - watch:
            - pkg: cinder-scheduler
            - file: /etc/cinder/cinder.conf
            - file: /etc/cinder/policy.json
    require:
        - pkg: cinder-scheduler
        - file: /etc/cinder/cinder.conf
        - file: /etc/cinder/policy.json
