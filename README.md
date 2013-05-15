OpenStack Salt States
=====================

These states are flexible and extensible.

They are designed to do large multi-node deployments, and to allow for
auto-discovery of different services and addresses.

There are few requirements for use.

Where to put it
---------------

This repository is designed to be used as `$SALT_ROOT/openstack`. For
example, this will generally be `/srv/salt/openstack`.

This structure was chosen so that you can easily import it as a submodule
within a git repo with your other salt states (and possibly pillar data).

Ceph configuration
------------------

First, setup some pillar data for your storage configuration.

    ceph:
        devices:
            node-0025904fc1de:
                0: sdb
                1: sdc
            node-0025904fc34c:
                2: sdb
                3: sdc
        monitors:
            - node-0025904fc1de
            - node-0025904fc34c

Then run `state.sls` `ceph` on all participating nodes in order to
deploy the configuration.  To make the cluster, you will then run:

    mkcephfs -a -c /etc/ceph/ceph.conf --mkfs

That's it!

Configuration
-------------

You can find full information about configuration values in `config.sls` and
`ceph/config.sls`.
