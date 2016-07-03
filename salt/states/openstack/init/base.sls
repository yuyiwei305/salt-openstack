ntp-service:
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://openstack/init/files/ntp.conf
    - user: root
    - group: root
    - mode: 644
  pkg.installed:
    - name: ntp
  service.running:
    - name: ntpd
    - enable: True

epel_repo:
  pkg.installed:
    - name: epel-release
    - unless: rpm -qa | grep epel-release 
yum_repo_release:
  cmd.run:
    - name: yum -y install  https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-2.noarch.rpm
    - require:
      - pkg: epel_repo
    - unless: rpm -qa | grep rdo-release-kilo-2

pkg-base:
  pkg.installed:
    - names:
      - lrzsz
      - MySQL-python
      
