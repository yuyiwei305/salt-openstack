keystone-install:
  pkg.installed:
    - names:
      - openstack-keystone
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

mem-run:
  service.running:
    - name: memcached
    - enable: True
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

