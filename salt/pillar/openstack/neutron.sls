neutron:
  MYSQL_SERVER: controller
  NEUTRON_IP: 172.16.0.1
  NEUTRON_DB_NAME: neutron
  NEUTRON_DB_USER: neutron
  NEUTRON_DB_PASS: neutron
  AUTH_KEYSTONE_HOST: 172.16.0.1
  AUTH_KEYSTONE_PORT: 35357
  AUTH_KEYSTONE_PROTOCOL: http
  AUTH_ADMIN_PASS: neutron
  VM_INTERFACE: enp6s0f0
  NOVA_URL: http://172.16.0.1:8774/v2
  NOVA_ADMIN_USER: nova
  NOVA_ADMIN_PASS: nova
  NOVA_ADMIN_TENANT: service
#  NOVA_ADMIN_TENANT_ID: b28c286fd0f84130a2722065976623ea
  NOVA_ADMIN_AUTH_URL: http://172.16.0.1:35357/v2.0
  AUTH_NEUTRON_ADMIN_TENANT: service
  AUTH_NEUTRON_ADMIN_USER: neutron
  AUTH_NEUTRON_ADMIN_PASS: neutron
  DB_ALLOW: neutron.*
  HOST_ALLOW: 172.16.0.0/255.255.0.0
