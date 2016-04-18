nova:
  MYSQL_SERVER: localhost
  NOVA_IP: 10.105.12.205
  NOVA_DB_NAME: nova
  NOVA_DB_USER: nova
  NOVA_DB_PASS: nova
  DB_ALLOW: nova.*
  HOST_ALLOW: localhost
  RABBITMQ_HOST: 10.105.12.205
  RABBITMQ_PORT: 5672
  RABBITMQ_USER: openstack
  RABBITMQ_PASS: rabbit
  AUTH_KEYSTONE_HOST: 10.105.12.205
  AUTH_KEYSTONE_PORT: 35357
  AUTH_KEYSTONE_PROTOCOL: http
  AUTH_NOVA_ADMIN_TENANT: service
  AUTH_NOVA_ADMIN_USER: nova
  AUTH_NOVA_ADMIN_PASS: nova
  GLANCE_HOST: 10.105.12.205
  AUTH_KEYSTONE_URI: http://10.105.12.205:5000
  NEUTRON_URL: http://10.105.12.205:9696
  NEUTRON_ADMIN_USER: neutron
  NEUTRON_ADMIN_PASS: neutron
  NEUTRON_ADMIN_TENANT: service
  NEUTRON_ADMIN_AUTH_URL: http://10.105.12.205:5000/v2.0
  NOVNCPROXY_BASE_URL: http://10.105.12.205:6080/vnc_auto.html
  AUTH_URI: http://10.105.12.205:5000
