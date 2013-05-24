{% import "openstack/config.sls" as config with context %}
include:
    - openstack.quantum.base

/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini:
    file.managed:
        - source: salt://openstack/quantum/ovs_quantum_plugin.ini
        - user: quantum
        - group: quantum
        - mode: 0600
        - template: jinja
        - context:
            mysql_username: {{ config.mysql_quantum_username }}
            mysql_password: {{ config.mysql_quantum_password }}
            mysql_database: {{ config.mysql_quantum_database }}
            mysql_host: {{ config.mysql_hosts|first }}
            ip: {{ config.internal_ip }}
    require:
        - user: quantum
        - group: quantum

openvswitch-brcompat:
    pkg:
        - installed

openvswitch-switch:
    pkg:
        - installed
    service:
        - running
        - watch:
            - pkg: openvswitch-switch

br-int:
    cmd.run:
        - name: ovs-vsctl br-exists br-int || ovs-vsctl add-br br-int
    require:
         - service: openvswitch-switch

br-ex:
    cmd.run:
        - name: ovs-vsctl br-exists br-ex || ovs-vsctl add-br br-ex
    require:
         - service: openvswitch-switch
