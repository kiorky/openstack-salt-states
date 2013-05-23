{% import "openstack/config.sls" as config with context %}
include:
    - openstack.nova.base
    - openstack.nova.common

{{ config.package("nova-compute") }}
    service.running:
        - name: nova-compute
        - enable: True
        - watch:
            - pkg: nova-compute
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
    require:
        - service: nova-api
        - pkg: nova-compute
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json

{{ config.package("libvirt-bin") }}
    service.running:
        - name: libvirt-bin
        - enable: True

{{ config.vms("cobalt-compute") }}
{{ config.vms("vms-apparmor") }}
