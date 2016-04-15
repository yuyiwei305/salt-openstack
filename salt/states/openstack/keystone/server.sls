keystone-install:
  pkg.installed:
    - names:
      - openstack-keystone
      - python-openstackclient
      - memcached
      - python-memcached
      - python-keystoneclient

keystone-config:
  file.managed:
    - name: /etc/keystone/keystone.conf
    - source: salt://openstack/keystone/files/keystone.conf
    - user: root
    - user: root
    - template: jinja
    - defaults:
      KEYSTONE_ADMIN_TOKEN: {{ pillar['keystone']['KEYSTONE_ADMIN_TOKEN'] }}
      MYSQL_SERVER: {{ pillar['keystone']['MYSQL_SERVER'] }}
      KEYSTONE_DB_PASS: {{ pillar['keystone']['KEYSTONE_DB_PASS'] }}
      KEYSTONE_DB_USER: {{ pillar['keystone']['KEYSTONE_DB_USER'] }}
      KEYSTONE_DB_NAME: {{ pillar['keystone']['KEYSTONE_DB_NAME'] }}
    - require:
      - pkg: keystone-install  


keystone-db-sync:
  cmd.run:
    - name: keystone-manage db_sync && touch /etc/keystone/keystone_db.lock
    - unless: test -f /etc/keystone/keystone_db.lock
    - require:
      - pkg: keystone-install
      - file: keystone-config


openstack-keystone-run:
  service.running:
    - name: openstack-keystone
    - enable: True
    - require:
      - pkg: keystone-install
    - watch:
      - file: keystone-config
      - cmd: keystone-db-sync





keystone-init:    
  file.managed:
    - name: /etc/keystone/keystone_init.sh
    - source: salt://openstack/keystone/files/keystone_init.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      KEYSTONE_ADMIN_TOKEN: {{ pillar['keystone']['KEYSTONE_ADMIN_TOKEN'] }}
      KEYSTONE_ADMIN_TENANT: {{ pillar['keystone']['KEYSTONE_ADMIN_TENANT'] }}
      KEYSTONE_ADMIN_USER: {{ pillar['keystone']['KEYSTONE_ADMIN_USER'] }}
      KEYSTONE_ADMIN_PASSWD: {{ pillar['keystone']['KEYSTONE_ADMIN_PASSWD'] }}
      KEYSTONE_ROLE_NAME: {{ pillar['keystone']['KEYSTONE_ROLE_NAME'] }}
      KEYSTONE_AUTH_URL: {{ pillar['keystone']['KEYSTONE_AUTH_URL'] }}
      KEYSTONE_IP: {{ pillar['keystone']['KEYSTONE_IP'] }}
  cmd.run:
    - name: sleep 10 && bash /etc/keystone/keystone_init.sh && touch /etc/keystone/keystone-init.lock
    - require:
      - file: keystone-init
      - service: openstack-keystone-run
    - unless: test -f /etc/keystone-init.lock

