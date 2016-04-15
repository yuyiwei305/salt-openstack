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
    - sources:
      - epel-release-7-5.noarch: http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    - unless: rpm -qa | grep epel-release-7-5.noarch  

yum_repo_release:
  pkg.installed:
    - sources:
      - rdo-release-kilo-1.noarch: https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm
    - require:
      - pkg: epel_repo
    - unless: rpm -qa | grep rdo-release-kilo-1

pkg-base:
  pkg.installed:
    - names:
      - lrzsz
      - MySQL-python
      
