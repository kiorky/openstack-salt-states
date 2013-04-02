{% import "openstack/config.sls" as config with context %}

mysql-server:
    pkg.installed

mysql:
    service:
        - running
    require:
        - pkg.installed: mysql-server
    watch:
        - pkg.installed: mysql-server

keystone:
    mysql_database.present:
        - name: {{ config.mysql_keystone_database }}
    mysql_user.present:
        - name: {{ config.mysql_keystone_username }}
        - password: {{ config.mysql_keystone_password }}
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_keystone_database }}.*
        - user: {{ config.mysql_keystone_username }}
    require:
        - service: mysql
nova:
    mysql_database.present:
        - name: {{ config.mysql_nova_database }}
    mysql_user.present:
        - name: {{ config.mysql_nova_username }}
        - password: {{ config.mysql_nova_password }}
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_nova_database }}.*
        - user: {{ config.mysql_nova_username }}
    require:
        - service: mysql
glance:
    mysql_database.present:
        - name: {{ config.mysql_glance_database }}
    mysql_user.present:
        - name: {{ config.mysql_glance_username }}
        - password: {{ config.mysql_glance_password }}
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_glance_database }}.*
        - user: {{ config.mysql_glance_username }}
    require:
        - service: mysql
cinder:
    mysql_database.present:
        - name: {{ config.mysql_cinder_database }}
    mysql_user.present:
        - name: {{ config.mysql_cinder_username }}
        - password: {{ config.mysql_cinder_password }}
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_cinder_database }}.*
        - user: {{ config.mysql_cinder_username }}
    require:
        - service: mysql
horizon:
    mysql_database.present:
        - name: {{ config.mysql_horizon_database }}
    mysql_user.present:
        - name: {{ config.mysql_horizon_username }}
        - password: {{ config.mysql_horizon_password }}
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_horizon_database }}.*
        - user: {{ config.mysql_horizon_username }}
    require:
        - service: mysql
quantum:
    mysql_database.present:
        - name: {{ config.mysql_quantum_database }}
    mysql_user.present:
        - name: {{ config.mysql_quantum_username }}
        - password: {{ config.mysql_quantum_password }}
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_quantum_database }}.*
        - user: {{ config.mysql_quantum_username }}
    require:
        - service: mysql

{% set res = salt['data.update']('openstack.mysql', config.internal_ip) %}
