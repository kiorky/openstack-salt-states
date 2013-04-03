{% import "openstack/ceph/config.sls" as config with context %}

ceph-keyring:
  cmd.run:
      - name: 'wget -q -O - https://raw.github.com/ceph/ceph/master/keys/release.asc | sudo apt-key add -'
      - unless: 'apt-key list | grep -q -i ceph' 
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

{% set i = 0 %}
{% for (host, _) in config.devices|dictsort %}
{% if grains['localhost'] == host %}
/var/lib/ceph/mon/ceph-{{i}}:
    file.directory:
        - owner: root
        - group: root
        - mode: 0755
        - makedirs: true
{% endif %}
{% set i = i + 1 %}
{% endfor %}

{% set i = 0 %}
{% for (host, devices) in config.devices|dictsort %}
{% for device in devices %}
{% if grains['localhost'] == host %}
/var/lib/ceph/osd/ceph-{{i}}:
    file.directory:
        - owner: root
        - group: root
        - mode: 0755
        - makedirs: true
{% endif %}
{% set i = i + 1 %}
{% endfor %}
{% endfor %}
