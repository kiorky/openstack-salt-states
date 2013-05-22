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

mysql-keystone:
    mysql_database.present:
        - name: {{ config.mysql_keystone_database }}
    mysql_user.present:
        - name: {{ config.mysql_keystone_username }}
        - password: {{ config.mysql_keystone_password }}
        - host: "%"
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_keystone_database }}.*
        - user: {{ config.mysql_keystone_username }}
        - host: "%"
    require:
        - service: mysql
mysql-nova:
    mysql_database.present:
        - name: {{ config.mysql_nova_database }}
    mysql_user.present:
        - name: {{ config.mysql_nova_username }}
        - password: {{ config.mysql_nova_password }}
        - host: "%"
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_nova_database }}.*
        - user: {{ config.mysql_nova_username }}
        - host: "%"
    require:
        - service: mysql
mysql-glance:
    mysql_database.present:
        - name: {{ config.mysql_glance_database }}
    mysql_user.present:
        - name: {{ config.mysql_glance_username }}
        - password: {{ config.mysql_glance_password }}
        - host: "%"
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_glance_database }}.*
        - user: {{ config.mysql_glance_username }}
        - host: "%"
    require:
        - service: mysql
mysql-cinder:
    mysql_database.present:
        - name: {{ config.mysql_cinder_database }}
    mysql_user.present:
        - name: {{ config.mysql_cinder_username }}
        - password: {{ config.mysql_cinder_password }}
        - host: "%"
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_cinder_database }}.*
        - user: {{ config.mysql_cinder_username }}
        - host: "%"
    require:
        - service: mysql
mysql-quantum:
    mysql_database.present:
        - name: {{ config.mysql_quantum_database }}
    mysql_user.present:
        - name: {{ config.mysql_quantum_username }}
        - password: {{ config.mysql_quantum_password }}
        - host: "%"
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_quantum_database }}.*
        - user: {{ config.mysql_quantum_username }}
        - host: "%"
    require:
        - service: mysql
mysql-horizon:
    mysql_database.present:
        - name: {{ config.mysql_horizon_database }}
    mysql_user.present:
        - name: {{ config.mysql_horizon_username }}
        - password: {{ config.mysql_horizon_password }}
        - host: "%"
    mysql_grants.present:
        - grant: all privileges
        - database: {{ config.mysql_horizon_database }}.*
        - user: {{ config.mysql_horizon_username }}
        - host: "%"
    require:
        - service: mysql
