rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server
  service.running:
    - name: rabbitmq-server
    - enable: True
    - require:
      - pkg: rabbitmq-server
  cmd.run:
    - name: rabbitmqctl add_user openstack rabbit && rabbitmqctl set_permissions openstack ".*" ".*" ".*" 
    - unless: rabbitmqctl list_users   |grep openstack
