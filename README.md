Adminapi Puppet Module
======================

Hiera Backend Example
---------------------

```yaml
---
version: 5
hierarchy:
  - name: Serveradmin Hiera
    data_hash: adminapi::hiera_backend
    options:
      puppet_class: ig::server
      restrict:
        - hostname
        - loadbalancer:
          - intern_ip
          - primary_ip6
          - route_network:
            - object_id
            - intern_ip
            - primary_ip6
            - default_gateway:
              - object_id
              - intern_ip
              - primary_ip6
          - state_limit
```

License
-------

The project is released under the MIT License.  The MIT License is registered
with and approved by the [Open Source Initiative](https://opensource.org/licenses/MIT).
