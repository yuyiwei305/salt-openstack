#! /usr/bin/bash


systemctl stop firewalld
systemctl disable firewalld
setenforce 0
yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch  git 
yum -y install salt-master salt-minion
sleep 10
cp -a /root/salt-openstack/salt /srv/
cp -a /root/salt-openstack/config/* /etc/salt/
sleep 1
service salt-master start
service salt-minion start
