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

Credits
---------
- Initially inspired from https://github.com/gridcentric/openstack-salt-states
- Makina Corpus for funding a large part of this work

