{% import "openstack/ceph/config.sls" as config with context %}

ceph-keyring:
  cmd.run:
      - name: wget -q -O - https://raw.github.com/ceph/ceph/master/keys/release.asc | sudo apt-key add -
      - unless: apt-key list | grep -q -i ceph'
ceph:
    pkgrepo.managed:
        - name: {{ config.source }}
        - baseurl: {{ config.source }}
        - humanname: ceph
        - file: /etc/apt/sources.list.d/ceph.list
    pkg:
        - latest
    require:
        - pkgrepo: {{ config.source }}
        - state: ceph-keyring

/etc/ceph/ceph.conf:
    file.managed:
        - source: salt://openstack/ceph/ceph.conf
        - owner: root
        - group: root
        - mode: 0644
        - template: jinja
        - context:
            devices: {{ config.devices }}
            fsid: {{ config.fsid }}
            ip: {{ config.ip }}

{% for host in config.devices.keys()|sort %}
{% if grains['localhost'] == host %}
/var/lib/ceph/mon/ceph-{{host}}:
    file.directory:
        - owner: root
        - group: root
        - mode: 0755
        - makedirs: true
{% endif %}
{% endfor %}

{% for (host, devices) in config.devices|dictsort %}
{% for (id, device) in devices|dictsort %}
{% if grains['localhost'] == host %}
/var/lib/ceph/osd/ceph-{{id}}:
    file.directory:
        - owner: root
        - group: root
        - mode: 0755
        - makedirs: true
{% endif %}
{% endfor %}
{% endfor %}

{% for id in config.auth %}
/etc/ceph/ceph.{{id}}.keyring:
    file.managed:
        - source: salt://openstack/ceph/keyring
        - owner: {{config.auth[id].get("owner", "root")}}
        - group: {{config.auth[id].get("group", "root")}}
        - mode: {{config.auth[id].get("mode", 0600)}}
        - template: jinja
        - context:
            id: {{id}}
            key: {{config.auth[id].get("key", "")}}
{% endfor %}
