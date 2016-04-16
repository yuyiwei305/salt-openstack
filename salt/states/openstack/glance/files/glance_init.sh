source /root/admin-openrc.sh

openstack user create --password {{AUTH_GLANCE_ADMIN_USER}} {{AUTH_GLANCE_ADMIN_PASS}}
openstack role add --project service --user {{AUTH_GLANCE_ADMIN_USER}} admin
openstack service create --name {{AUTH_GLANCE_ADMIN_USER}} \
  --description "OpenStack Image service" image
openstack endpoint create \
  --publicurl http://{{GLANCE_IP}}:9292 \
  --internalurl http://{{GLANCE_IP}}:9292 \
  --adminurl http://{{GLANCE_IP}}:9292 \
  --region RegionOne \
  image


