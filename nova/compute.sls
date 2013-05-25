{% import "openstack/config.sls" as config with context %}
include:
    - openstack.nova.base

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
    service.running:
        - name: cobalt-compute
        - enable: True
        - require:
            - pkg: cobalt-compute
        - watch:
            - pkg: cobalt-compute
{{ config.vms("vms-apparmor") }}
{{ config.vms("vms") }}
