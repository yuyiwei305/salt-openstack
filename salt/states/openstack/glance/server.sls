include:
  - openstack.glance.init

glance_install:
  pkg.installed:
    - names: 
      - openstack-glance
      - python-glance 
      - python-glanceclient

glance_configs:
  file.recurse:
    - name: /etc/glance
    - source: salt://openstack/glance/files/config
    - root: glance
    - group: glance
    - template: jinja
    - defaults:
      MYSQL_SERVER: {{ pillar['keystone']['MYSQL_SERVER'] }}
      GLANCE_IP: {{ pillar['glance']['GLANCE_IP'] }}
      GLANCE_DB_PASS: {{ pillar['glance']['GLANCE_DB_PASS'] }}
      GLANCE_DB_USER: {{ pillar['glance']['GLANCE_DB_USER'] }}
      GLANCE_DB_NAME: {{ pillar['glance']['GLANCE_DB_NAME'] }}
      RABBITMQ_HOST: {{ pillar['rabbit']['RABBITMQ_HOST'] }}
      RABBITMQ_PORT: {{ pillar['rabbit']['RABBITMQ_PORT'] }}
      RABBITMQ_USER: {{ pillar['rabbit']['RABBITMQ_USER'] }}
      RABBITMQ_PASS: {{ pillar['rabbit']['RABBITMQ_PASS'] }}
      AUTH_KEYSTONE_HOST: {{ pillar['glance']['AUTH_KEYSTONE_HOST'] }}
      AUTH_KEYSTONE_PORT: {{ pillar['glance']['AUTH_KEYSTONE_PORT'] }}
      AUTH_KEYSTONE_PROTOCOL: {{ pillar['glance']['AUTH_KEYSTONE_PROTOCOL'] }}
      AUTH_GLANCE_ADMIN_TENANT: {{ pillar['glance']['AUTH_GLANCE_ADMIN_TENANT'] }}
      AUTH_GLANCE_ADMIN_USER: {{ pillar['glance']['AUTH_GLANCE_ADMIN_USER'] }}
      AUTH_GLANCE_ADMIN_PASS: {{ pillar['glance']['AUTH_GLANCE_ADMIN_PASS'] }}



glance-db-sync:
  cmd.run:
    - name: su -s /bin/sh -c "glance-manage db_sync" glance && touch /etc/glance/glance-datasync.lock && chown -R glance:glance /var/log/glance/*
    - require:
      - pkg: glance_install
      - cmd: glance-init
    - unless: test -f /etc/glance/glance-datasync.lock


glance-api-run:
  service.running:
    - name: openstack-glance-api.service
    - enable: True
    - watch:
      - file: glance_configs
    - require:
      - pkg: glance_install
      - cmd: glance-db-sync

glance-registry-run:
  service.running:
    - name: openstack-glance-registry.service
    - enable: True
    - watch:
      - file: glance_configs
    - require:
      - pkg: glance_install
      - cmd: glance-db-sync
