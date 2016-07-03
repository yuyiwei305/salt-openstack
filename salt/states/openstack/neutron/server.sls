include:
  - openstack.neutron.init
  - openstack.neutron.server-conf

neutron-server-install:
  pkg.installed:
    - names:
      - openstack-neutron
      - openstack-neutron-ml2
      - python-neutronclient



neutron-server-renew:
  cmd.run:
    - name: ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini && touch /etc/neutron/neutron-renew.lock
    - require:
      - pkg: neutron-server-install
    - unless: test -f /etc/neutron/neutron-renew.lock

neutron-db-sync:
  cmd.run:
    - name: su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron && touch /etc/neutron/neutron-db-sync.lock 

    - require:
      - cmd: neutron-init
      - pkg: neutron-server-install
    - unless: test -f /etc/neutron/neutron-db-sync.lock

neutron-server-run:
  service.running:
    - name: neutron-server.service
    - enable: True
    - watch:
      - file: server-conf-neutron-conf
      - file: server-conf-ml2-conf
    - require:
      - pkg: neutron-server-install
      - cmd: neutron-db-sync

      
