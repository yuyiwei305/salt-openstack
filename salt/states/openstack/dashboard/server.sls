install-dashboard:
  pkg.installed:
    - names:
      - openstack-dashboard
      - httpd
      - mod_wsgi
      - memcached
      - python-memcached

dashboard-config:
  file.managed:
    - name: /etc/openstack-dashboard/local_settings
    - source: salt://openstack/dashboard/files/local_settings
    - template: jinja
    - defaults:
      CONTROLLER_HOST: {{ pillar['dashboard']['CONTROLLER_HOST'] }}
    - require:
      - pkg: install-dashboard
  cmd.run:
    - name: chown -R apache:apache /usr/share/openstack-dashboard/static

