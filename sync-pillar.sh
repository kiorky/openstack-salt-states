P="PILLAR.sample"
cp real-pillar $P
keys=""
keys="$keys vhost mysql_root password token region tenant_name"
keys="$keys project_password project_tenant project_user"
for i in $keys;do
    sed -re "s/(.*$i)(=|:\s+).*/\1\2'xxxx'/g" -i $P
done
sed -re "/rpn_ip/d" -i $P
cat $P
