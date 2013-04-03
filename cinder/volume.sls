{% import "openstack/config.sls" as config with context %}
include:
    - base
    - ceph

{{ config.package("cinder-volume") }}
    service.running:
        - enable: True
        - watch:
            - file: /etc/cinder/cinder.conf
            - file: /etc/cinder/policy.json
            - pkg: cinder-volume
    require:
        - file: /etc/cinder/cinder.conf
        - file: /etc/cinder/policy.json
        - file: /etc/ceph/ceph.conf
