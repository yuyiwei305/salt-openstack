#! /usr/bin/bash


systemctl stop firewalld
systemctl disable firewalld
setenforce 0
yum -y install epel-release git 
yum -y install salt-master salt-minion
git clone https://github.com/yuyiwei305/salt-openstack
sleep 10
cp -a /root/salt-openstack/salt /srv/
cp -a /root/salt-openstack/config/* /etc/salt/


