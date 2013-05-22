{% import "openstack/config.sls" as config with context %}
include:
    - openstack.keystone.base

{{ config.package("keystone") }}
    service.running:
        - name: keystone
        - enable: True
        - watch:
            - pkg: keystone
            - file: /etc/keystone/keystone.conf
            - file: /etc/keystone/policy.json
            - file: /etc/keystone/init.sh
    require:
        - file: /etc/keystone/keystone.conf
        - file: /etc/keystone/policy.json
        - file: /etc/keystone/init.sh
