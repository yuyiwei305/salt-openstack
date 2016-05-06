keystone-install:
  pkg.installed:
    - names:
      - openstack-keystone
      - memcached
      - python-memcached
      - python-openstackclient
    
keystone-config:
  file.managed:
    - name: /etc/keystone/keystone.conf
    - source: salt://openstack/keystone/files/keystone.conf
    - user: root
    - user: root
    - mode: 755
    - template: jinja
    - defaults:
      KEYSTONE_ADMIN_TOKEN: {{ pillar['keystone']['KEYSTONE_ADMIN_TOKEN'] }}
      MYSQL_SERVER: {{ pillar['keystone']['MYSQL_SERVER'] }}
      KEYSTONE_DB_PASS: {{ pillar['keystone']['KEYSTONE_DB_PASS'] }}
      KEYSTONE_DB_USER: {{ pillar['keystone']['KEYSTONE_DB_USER'] }}
      KEYSTONE_DB_NAME: {{ pillar['keystone']['KEYSTONE_DB_NAME'] }}
    - require:
      - pkg: keystone-install  

mem-run:
  service.running:
    - name: memcached
    - enable: True
    - require:
      - pkg: keystone-install
    - watch:
      - file: keystone-config      


keystone-db-sync:
  cmd.run:
    - name: su -s /bin/sh -c "keystone-manage db_sync" keystone  && touch /etc/keystone/keystone_db.lock
    - unless: test -f /etc/keystone/keystone_db.lock
    - require:
      - pkg: keystone-install
      - cmd: keystone-init
      - file: keystone-config


openstack-keystone-run:
  service.running:
    - name: openstack-keystone
    - enable: True
    - require:
      - pkg: keystone-install
    - watch:
      - file: keystone-config


include:
  - openstack.keystone.init



creat-admin-openrc:
  file.managed:
    - name: /root/admin-openrc.sh
    - source: salt://openstack/keystone/files/admin-openrc.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      KEYSTONE_ADMIN_TENANT: {{ pillar['keystone']['KEYSTONE_ADMIN_TENANT'] }}
      KEYSTONE_ADMIN_USER: {{ pillar['keystone']['KEYSTONE_ADMIN_USER'] }}
      KEYSTONE_ADMIN_PASSWD: {{ pillar['keystone']['KEYSTONE_ADMIN_PASSWD'] }}
      KEYSTONE_AUTH_URL: {{ pillar['keystone']['KEYSTONE_AUTH_URL'] }}

