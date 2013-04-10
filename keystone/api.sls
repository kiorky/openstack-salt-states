{% import "openstack/config.sls" as config with context %}
include:
    - base

{{ config.package("keystone") }}
    service.running:
        - enable: True
        - watch:
            - pkg: keystone
    require:
        - file: /etc/keystone/keystone.conf
        - file: /etc/keystone/policy.json
        - file: /etc/keystone/init.sh
