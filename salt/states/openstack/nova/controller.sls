include:
  - openstack.nova.init


nova-control-install:
  pkg.installed:
    - names:
      - openstack-nova-api
      - openstack-nova-cert
      - openstack-nova-conductor
      - openstack-nova-console
      - openstack-nova-novncproxy
      - openstack-nova-scheduler
      - python-novaclient



nova-config:
  file.managed:
    - name: /etc/nova/nova.conf
    - source: salt://openstack/nova/files/config/nova.conf
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
      VNCSERVER_PROXYCLIENT: {{ grains['ipv4'][1]  }}
      NEUTRON_IP: {{ pillar['neutron']['NEUTRON_IP'] }}
      AUTH_URI: {{ pillar['nova']['AUTH_URI'] }}
      AUTH_NEUTRON_ADMIN_TENANT: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_TENANT'] }}
      AUTH_NEUTRON_ADMIN_USER: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_USER'] }}
      AUTH_NEUTRON_ADMIN_PASS: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_PASS'] }}


nova-db-sync:
  cmd.run:
    - name: su -s /bin/sh -c "nova-manage db sync" nova && touch /etc/nova/nova-db.lock
    - require:
      - pkg: nova-control-install
    - unless: test -f /etc/nova/nova-db.lock

openstack-nova-api-server:
  service.running:
    - name: openstack-nova-api
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

openstack-nova-cert-server:
  service.running:
    - name: openstack-nova-cert
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

openstack-nova-consoleauth-server:
  service.running:
    - name: openstack-nova-consoleauth
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync


openstack-nova-scheduler-server:
  service.running:
    - name: openstack-nova-scheduler
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

openstack-nova-conductor-server:
  service.running:
    - name: openstack-nova-conductor
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

openstack-nova-novncproxy-server:
  service.running:
    - name: openstack-nova-novncproxy
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

