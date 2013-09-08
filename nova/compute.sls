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

stop-apparmor:
    cmd.run:
        - name: /etc/init.d/apparmor stop && /etc/init.d/apparmor teardown && update-rc.d -f apparmor remove

/etc/libvirt/qemu.conf:
    file.managed:
        - source: salt://openstack/nova/qemu.conf
        - user: root
        - group: root
        - mode: 0644

restart-libvirtd:
    cmd.run:
        - name: stop libvirt-bin && start libvirt-bin
        - require:
            - file: /etc/libvirt/qemu.conf
        - watch:
            - file: /etc/libvirt/qemu.conf

stop-cgroups:
    cmd.run:
        - name: stop cgroup-lite

{{ config.vms("vms") }}
{{ config.vms("vms-rados") }}

/etc/sysconfig/vms:
    file.managed:
        - source: salt://openstack/nova/vms
        - user: root
        - group: root
        - mode: 0644

make-disk-url:
    cmd.run:
        - name: rados mkpool vmsdisk
        - unless: rados lspools | grep vmsdisk

make-mem-url:
    cmd.run:
        - name: rados mkpool vmsmem
        - unless: rados lspools | grep vmsmem

{{ config.vms("cobalt-compute") }}
    service.running:
        - name: cobalt-compute
        - enable: True
        - require:
            - pkg: cobalt-compute
            - cmd: stop-apparmor
            - cmd: stop-cgroups
            - file: /etc/sysconfig/vms
        - watch:
            - pkg: cobalt-compute
            - cmd: stop-apparmor
            - cmd: stop-cgroups
            - file: /etc/sysconfig/vms
