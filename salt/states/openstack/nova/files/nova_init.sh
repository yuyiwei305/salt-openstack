source admin-openrc.sh
	
openstack user create --password {{AUTH_NOVA_ADMIN_USER}} {{AUTH_NOVA_ADMIN_PASS}}
openstack role add --project service {{AUTH_NOVA_ADMIN_TENANT}} --user {{AUTH_NOVA_ADMIN_USER}} admin
openstack service create --name nova \
 --description "OpenStack Compute" compute
openstack endpoint create \
  --publicurl http://{{NOVA_IP}}:8774/v2/%\(tenant_id\)s \
  --internalurl http://{{NOVA_IP}}:8774/v2/%\(tenant_id\)s \
  --adminurl http://{{NOVA_IP}}:8774/v2/%\(tenant_id\)s \
  --region RegionOne \
  compute

