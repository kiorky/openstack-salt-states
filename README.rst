OpenStack Salt States
=====================

.. contents::

- :**Status**: Not all is implemented yet !
- :**disclaimer**: based to deploy on ubuntu server and tested with openstack **grizzly**
- :**note**: Idea is to grab as much info from pillar as we can to offer flexibility in configuration, please read the states to see avalaible options

- These states are flexible and extensible.
- They are designed to do large multi-node deployments,
- There are few requirements for use.


Where to put it
---------------

This repository is designed to be used as `$SALT_ROOT/openstack`. For
example, this will generally be `/srv/salt/openstack`.

This structure was chosen so that you can easily import it as a submodule
within a git repo with your other salt states (and possibly pillar data).

Choices
------------
- Mysql to store databases
- Rabbitmq for the queuing system
- Cinder/Swift with Ceph backend for the obs / rbd system

Architecture
-----------------
States
+++++++++++++++++++++

Backend states
****************
Some states were made to leverage the initialisation of related tools & databases which openstack will use

Rabbitmq
~~~~~~~~~~
- Include **openstack.backend.rabbitmq.sls** to nitialise a rabbitmq server with a specific vhost

Ceph
~~~~~~~~~~
- Include **openstack.backend.ceph.sls** to initialise a ceph installation

Mysql
~~~~~~~~~~
- Include **openstack.backend.mysql.sls** to initialise all openstack needed databases

Openstack parts
****************
Keystone
~~~~~~~~~~
- Include **openstack.keystone.api.sls** to initialise a keystone server and all openstack based services, tenants, users and roles
glance
~~~~~~~~~~
- Include **openstack.keystone.{api,registry}.sls** to initialise a keystone server and all openstack based services, tenants, users and roles
- We include in glance registry as a default ubuntu images (**i386**, **adm64**) from **12.10** to **13.04**
neutron/quantum (quantum atm) server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cinder
~~~~~~~~~~~~~
nova compute
~~~~~~~~~~~~~
quantum/neutron network node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global States
****************
Controller node
~~~~~~~~~~~~~~~
- Include **controller_node.sls** to install openstack compute node (network server, api, keystone, cinder, glance)
- Include **standalone_controller_node.sls** to initialise mysql, rabbitmq, ceph & install openstack compute node

Network node
~~~~~~~~~~~~~~~
- Include **network_node.sls** to initialise a network node ()

Compute node
~~~~~~~~~~~~~~~
- Include **compute_node.sls** to initialise a nova-compute node + quantum agent

Credits
---------
- Initially inspired from https://github.com/gridcentric/openstack-salt-states
- Makina Corpus for funding a large part of this work

