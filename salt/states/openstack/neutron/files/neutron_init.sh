source admin-openrc.sh 

openstack user create --password {{AUTH_NEUTRON_ADMIN_PASS}} {{AUTH_NEUTRON_ADMIN_USER}}

openstack role add --project {{AUTH_NEUTRON_ADMIN_TENANT}} --user {{AUTH_NEUTRON_ADMIN_USER}} admin

openstack service create --name neutron \
--description "OpenStack Networking" network

openstack endpoint create \
--publicurl http://{{NEUTRON_IP}}:9696 \
--adminurl http://{{NEUTRON_IP}}:9696 \
--internalurl http://{{NEUTRON_IP}}:9696 \
--region RegionOne \
network

