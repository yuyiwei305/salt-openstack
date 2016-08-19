#! /usr/bin/bash

systemctl restart openstack-nova-api.service
systemctl restart openvswitch.service

ovs-vsctl add-br br-{{VM_INTERFACE}}
ovs-vsctl add-port br-{{VM_INTERFACE}}  {{VM_INTERFACE}}
ethtool -K {{VM_INTERFACE}} gro off

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

cp /usr/lib/systemd/system/neutron-openvswitch-agent.service \
/usr/lib/systemd/system/neutron-openvswitch-agent.service.orig
sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' \
/usr/lib/systemd/system/neutron-openvswitch-agent.service


