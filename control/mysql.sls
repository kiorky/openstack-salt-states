{% extends "openstack/config.base" %}

mysql-server:
    pkg.installed

mysqld:
    service:
        - running
    require:
        - pkg.installed: mysql-server
    watch:
        - pkg.installed: mysql-server

keystone:
    - mysql_database
        - present
        - name: {{mysql_keystone_database}}
    - mysql_user.present
        - name: {{ mysql_keystone_username }}
        - password: {{ mysql_keystone_password }}
    - mysql_grants.present:
        - grant: all privileges
        - database: {{ mysql_keystone_database }}.*
        - user: {{ mysql_keystone_username }}
    require:
        - service: mysqld
nova:
    - mysql_database.present
        - name: {{ mysql_nova_database }}
    - mysql_user.present
        - name: {{ mysql_nova_username }}
        - password: {{ mysql_nova_password }}
    - mysql_grants.present:
        - grant: all privileges
        - database: {{ mysql_nova_database }}.*
        - user: {{ mysql_nova_username }}
    require:
        - service: mysqld
glance:
    - mysql_database.present
        - name: {{ mysql_glance_database }}
    - mysql_user.present
        - name: {{ mysql_glance_username }}
        - password: {{ mysql_glance_password }}
    - mysql_grants.present:
        - grant: all privileges
        - database: {{ mysql_glance_database }}.*
        - user: {{ mysql_glance_username }}
    require:
        - service: mysqld
cinder:
    - mysql_database.present
        - name: {{ mysql_cinder_database }}
    - mysql_user.present
        - name: {{ mysql_cinder_username }}
        - password: {{ mysql_cinder_password }}
    - mysql_grants.present:
        - grant: all privileges
        - database: {{ mysql_cinder_database }}.*
        - user: {{ mysql_cinder_username }}
    require:
        - service: mysqld
horizon:
    - mysql_database.present
        - name: {{ mysql_horizon_database }}
    - mysql_user.present
        - name: {{ mysql_horizon_username }}
        - password: {{ mysql_horizon_password }}
    - mysql_grants.present:
        - grant: all privileges
        - database: {{ mysql_horizon_database }}.*
        - user: {{ mysql_horizon_username }}
    require:
        - service: mysqld
quantum:
    - mysql_database.present
        - name: {{ mysql_quantum_database }}
    - mysql_user.present
        - name: {{ mysql_quantum_username }}
        - password: {{ mysql_quantum_password }}
    - mysql_grants.present:
        - grant: all privileges
        - database: {{ mysql_quantum_database }}.*
        - user: {{ mysql_quantum_username }}
    require:
        - service: mysqld

publish:
    cmd.run:
        - name: salt-call data.update openstack.mysql {{ salt['network.ip_addrs']() }}
        - onlyif: true
