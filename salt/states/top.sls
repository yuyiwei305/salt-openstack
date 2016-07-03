base:
  'controller':
    - openstack.controller
  'nova*':
    - openstack.compute
  'network':
    - openstack.network
