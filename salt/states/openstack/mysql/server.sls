mysql-server:
  pkg.installed:
    - names: 
      - mariadb
      - mariadb-server


  file.managed:
    - name: /etc/my.cnf.d/mariadb_openstack.cnf
    - source: salt://openstack/mysql/files/mariadb_openstack.cnf

  service.running:
    - name: mariadb.service
    - enable: True
    - require:
      - pkg: mysql-server
    - watch:
      - file: mysql-server
