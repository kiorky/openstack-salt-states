{% import "openstack/config.sls" as config with context %}
include:
    - openstack.ceph
    - openstack.cinder.base

{{ config.package("cinder-volume") }}
    service.running:
        - enable: True
        - watch:
            - pkg: cinder-volume
            - file: /etc/cinder/cinder.conf
            - file: /etc/cinder/policy.json
            - file: /etc/ceph/ceph.conf
    require:
        - pkg: cinder-volume
        - file: /etc/cinder/cinder.conf
        - file: /etc/cinder/policy.json
        - file: /etc/ceph/ceph.conf

make-volumes:
    cmd.run:
        - name: rados mkpool volumes
    require:
        - file: /etc/ceph/ceph.conf
