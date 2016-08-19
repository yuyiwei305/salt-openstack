nova-compute-install:
  pkg.installed:
    - names: 
      - openstack-nova-compute
      - sysfsutils

nova-compute-config:
  file.managed:
    - name: /etc/nova/nova.conf
    - source: salt://openstack/nova/files/config/nova-compute.conf
    - user: nova
    - group: nova
    - template: jinja
    - defaults:
      MYSQL_SERVER: {{ pillar['nova']['MYSQL_SERVER'] }}
      NOVA_IP: {{ pillar['nova']['NOVA_IP'] }}
      NOVA_DB_PASS: {{ pillar['nova']['NOVA_DB_PASS'] }}
      NOVA_DB_USER: {{ pillar['nova']['NOVA_DB_USER'] }}
      NOVA_DB_NAME: {{ pillar['nova']['NOVA_DB_NAME'] }}
      RABBITMQ_HOST: {{ pillar['rabbit']['RABBITMQ_HOST'] }}
      RABBITMQ_PORT: {{ pillar['rabbit']['RABBITMQ_PORT'] }}
      RABBITMQ_USER: {{ pillar['rabbit']['RABBITMQ_USER'] }}
      RABBITMQ_PASS: {{ pillar['rabbit']['RABBITMQ_PASS'] }}
      AUTH_KEYSTONE_HOST: {{ pillar['nova']['AUTH_KEYSTONE_HOST'] }}
      AUTH_KEYSTONE_PORT: {{ pillar['nova']['AUTH_KEYSTONE_PORT'] }}
      AUTH_KEYSTONE_PROTOCOL: {{ pillar['nova']['AUTH_KEYSTONE_PROTOCOL'] }}
      AUTH_NOVA_ADMIN_TENANT: {{ pillar['nova']['AUTH_NOVA_ADMIN_TENANT'] }}
      AUTH_NOVA_ADMIN_USER: {{ pillar['nova']['AUTH_NOVA_ADMIN_USER'] }}
      AUTH_NOVA_ADMIN_PASS: {{ pillar['nova']['AUTH_NOVA_ADMIN_PASS'] }}
      NEUTRON_URL: {{ pillar['nova']['NEUTRON_URL'] }}
      NEUTRON_ADMIN_USER: {{ pillar['nova']['NEUTRON_ADMIN_USER'] }}
      NEUTRON_ADMIN_PASS: {{ pillar['nova']['NEUTRON_ADMIN_PASS'] }}
      NEUTRON_ADMIN_TENANT: {{ pillar['nova']['NEUTRON_ADMIN_TENANT'] }}
      NEUTRON_ADMIN_AUTH_URL: {{ pillar['nova']['NEUTRON_ADMIN_AUTH_URL'] }}
      NOVNCPROXY_BASE_URL: {{ pillar['nova']['NOVNCPROXY_BASE_URL'] }}
      AUTH_URI: {{ pillar['nova']['AUTH_URI'] }}
      VNCSERVER_PROXYCLIENT: {{ grains['ipv4'][1]  }}
      NEUTRON_IP: {{ pillar['neutron']['NEUTRON_IP'] }}
      AUTH_NEUTRON_ADMIN_TENANT: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_TENANT'] }}
      AUTH_NEUTRON_ADMIN_USER: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_USER'] }}
      AUTH_NEUTRON_ADMIN_PASS: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_PASS'] }}

libvirtd-server:
  service.running:
    - name: libvirtd
    - enable: True
    - watch:
      - file: /etc/nova
    - require:
      - pkg: nova-compute-install

openstack-nova-compute-server:
  service.running:
    - name: openstack-nova-compute
    - enable: True
    - watch:
      - file: /etc/nova
    - require:
      - pkg: nova-compute-install
