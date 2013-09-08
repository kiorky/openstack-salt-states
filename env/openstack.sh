# managed via salt, do not edit
. /etc/openstack/functions.sh
for i in /etc/openstack/openstack.env.d/*;do
    . $i
done
