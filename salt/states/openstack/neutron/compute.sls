compute-renew.cmd:
  cmd.run:
    - name: echo "net.ipv4.conf.all.rp_filter=0" > /etc/sysctl.conf && echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf && echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf && echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf && sysctl -p && touch /etc/neutron/compute-renew.lock
    - unless: test -f  /etc/neutron/compute-renew.lock

compute-network-server-install:
  pkg.installed:
    - names:
      - openstack-neutron
      - openstack-neutron-ml2
      - openstack-neutron-openvswitch


include:
  - openstack.neutron.compute-conf


compute-network-cmd:
  cmd.run:
    - name: ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini && cp /usr/lib/systemd/system/neutron-openvswitch-agent.service /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig && sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g'  /usr/lib/systemd/system/neutron-openvswitch-agent.service  && systemctl restart openstack-nova-compute.service &&  touch /etc/neutron/compute-network-cmd.lock 
    - unless: test -f /etc/neutron/compute-network-cmd.lock

compute-neutron-openvswitch-run:
  service.running:
    - name: openvswitch.service
    - enable: True
    - require:
      - pkg: compute-network-server-install


compute-neutron-openvswitch-agent.run:
  service.running:
    - name: neutron-openvswitch-agent.service
    - enable: True
    - require:
      - pkg: compute-network-server-install
      - cmd: compute-network-cmd

compute-neutron-nova-restart:
  cmd.run:
    - name: systemctl restart openstack-nova-compute.service
    - require:
      - service: compute-neutron-openvswitch-agent.run
