glance-init:
  file.managed:
    - name: /etc/glance/glance_init.sh
    - source: salt://openstack/glance/files/glance_init.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      KEYSTONE_ADMIN_TENANT: {{ pillar['keystone']['KEYSTONE_ADMIN_TENANT'] }}
      KEYSTONE_ADMIN_USER: {{ pillar['keystone']['KEYSTONE_ADMIN_USER'] }}
      KEYSTONE_ADMIN_PASSWD: {{ pillar['keystone']['KEYSTONE_ADMIN_PASSWD'] }}
      KEYSTONE_AUTH_URL: {{ pillar['keystone']['KEYSTONE_AUTH_URL'] }}
      GLANCE_IP: {{ pillar['glance']['GLANCE_IP'] }}
      AUTH_GLANCE_ADMIN_TENANT: {{ pillar['glance']['AUTH_GLANCE_ADMIN_TENANT'] }}
      AUTH_GLANCE_ADMIN_USER: {{ pillar['glance']['AUTH_GLANCE_ADMIN_USER'] }}
      AUTH_GLANCE_ADMIN_PASS: {{ pillar['glance']['AUTH_GLANCE_ADMIN_PASS'] }}
  cmd.run:
    - name: sleep 5 && bash /etc/glance/glance_init.sh && touch /etc/glance/glance-init.lock
    - require:
      - file: glance-init
      - cmd: glance-db-sync
    - unless: test -f /etc/glance/glance-init.lock
