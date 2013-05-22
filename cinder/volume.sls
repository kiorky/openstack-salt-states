{% import "openstack/config.sls" as config with context %}
include:
    - ceph
    - openstack.cinder.base

{{ config.package("cinder-volume") }}
    service.running:
        - enable: True
        - watch:
            - pkg: cinder-volume
            - file: /etc/cinder/cinder.conf
            - file: /etc/cinder/policy.json
            - file: /etc/cinder/secret.xml
            - file: /etc/ceph/ceph.conf
            - file: /etc/ceph/ceph.client.volumes.keyring
    require:
        - pkg: cinder-volume
        - file: /etc/cinder/cinder.conf
        - file: /etc/cinder/policy.json
        - file: /etc/cinder/secret.xml
        - file: /etc/ceph/ceph.conf
        - file: /etc/ceph/ceph.client.volumes.keyring

/etc/cinder/secret.xml:
    file.managed:
        - source: salt://openstack/cinder/secret.xml
        - user: cinder
        - group: cinder
        - mode: 0600
        - template: jinja
        - context:
            secret: {{ salt['cmd.run']("ceph auth get-or-create client.volumes mon 'allow rwx' osd 'allow *' | grep key | awk '{print $3;}'") }}

/etc/ceph/ceph.client.volumes.keyring:
    file.managed:
        - source: salt://openstack/cinder/ceph.client.volumes.keyring
        - user: cinder
        - group: cinder
        - mode: 0600
        - template: jinja
        - context:
            secret: {{ salt['cmd.run']("ceph auth get-or-create client.volumes mon 'allow rwx' osd 'allow *' | grep key | awk '{print $3;}'") }}

define-secret:
    cmd.run:
        - name: virsh secret-undefine 7a39b379-1bfe-6a01-aef5-5c4f5714f0db; virsh secret-define /etc/cinder/secret.xml
    require:
        - file: /etc/cinder/secret.xml

make-volumes:
    cmd.run:
        - name: rados mkpool volumes
    require:
        - file: /etc/ceph/ceph.conf
