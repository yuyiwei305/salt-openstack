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
    - name: sleep 5 && bash /etc/keystone/keystone_init.sh && touch /etc/keystone/keystone-init.lock
    - require:
      - file: keystone-init
      - service: openstack-keystone-run
    - unless: test -f /etc/keystone-init.lock
