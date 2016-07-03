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
  - openstack.neutron.network-conf

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
      VM_INTERFACE: {{ pillar['neutron']['VM_INTERFACE'] }}
  cmd.run:
    - name: bash /etc/neutron/openswitch-init.sh && touch /etc/neutron/openswitch-cmd.lock
    - require: 
      - file: network-openswitch-cmd
      - service: network-openswitch.service
    - unless: test -f /etc/neutron/openswitch-cmd.lock

network-neutron-openvswitch-agent.run:
  service.running:
    - name: neutron-openvswitch-agent.service
    - enable: True
    - require:
      - pkg: network-server-install
      - cmd: network-openswitch-cmd

network-neutron-l3-agent.run:
  service.running:
    - name: neutron-l3-agent.service
    - enable: True
    - watch:
      - file: network-conf-l3-conf
    - require:
      - pkg: network-server-install
      - cmd: network-openswitch-cmd

network-neutron-dhcp-agent.run:
  service.running:
    - name: neutron-dhcp-agent.service
    - enable: True
    - watch:
      - file: network-conf-dhcp-conf
    - require:
      - pkg: network-server-install
      - cmd: network-openswitch-cmd

network-neutron-metadata-agent.run:
  service.running:
    - name: neutron-metadata-agent.service
    - enable: True
    - watch:
      - file: network-conf-metadata-conf
    - require:
      - pkg: network-server-install
      - cmd: network-openswitch-cmd
