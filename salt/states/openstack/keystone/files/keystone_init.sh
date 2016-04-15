export OS_TOKEN={{KEYSTONE_ADMIN_TOKEN}}
export OS_URL=http://{{KEYSTONE_IP}}:35357/v2.0

openstack service create \
 --name keystone --description "OpenStack Identity" identity

openstack endpoint create \
 --publicurl http://{{KEYSTONE_IP}}:5000/v2.0 \
 --internalurl http://{{KEYSTONE_IP}}:5000/v2.0 \
 --adminurl http://{{KEYSTONE_IP}}:35357/v2.0 \
 --region RegionOne \
 identity

openstack project create --description "Admin Project" admin
openstack user create --password {{KEYSTONE_ADMIN_PASSWD}} {{KEYSTONE_ADMIN_USER}}
openstack role create {{KEYSTONE_ROLE_NAME}}
openstack role add --project admin --user {{KEYSTONE_ADMIN_USER}} {{KEYSTONE_ROLE_NAME}}
openstack project create --description "Service Project" service

# demo
openstack project create --description "Demo Project" demo	
openstack user create --password demo demo
openstack role create user
openstack role add --project demo --user demo user

sleep 3
unset OS_TOKEN OS_URL
