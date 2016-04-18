network-renew-cmd:
  cmd.run:
    - name: echo "net.ipv4.ip_forward = 1" > /etc/sysctl.conf && echo "net.ipv4.conf.all.rp_filter = 0" >> /etc/sysctl.conf  &&  echo "net.ipv4.conf.default.rp_filter = 0" >> /etc/sysctl.conf &&  sysctl -p && touch /etc/neutron/network-new.lock 
    - unless: test -f /etc/neutron/network-new.lock 

network-server-install:
  pkg.installed:
    - names:
      - openstack-neutron
      - openstack-neutron-ml2
      - openstack-neutron-openvswitch

include:
  - openstack.neutron.config

network-openswitch.service:
  service.running:
    - name: openvswitch.service
    - enable: True
    - require:
      - pkg: network-server-install

network-openswitch-cmd:
  file.managed:
    - name: /etc/neutron/openswitch-init.sh
    - source: salt://openstack/neutron/files/openswitch-init.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      NETWORKINTERFACE: {{ grains['ip_interfaces'][0] }}
  cmd.run:
    - name: bash /etc/neutron/openswitch-init.sh && touch /etc/neutron/openswitch-cmd.lock
    - require: 
      - file: network-openswitch-cmd
      - service: network-openswitch.service
    - unless: test -f /etc/neutron/openswitch-cmd.lock

