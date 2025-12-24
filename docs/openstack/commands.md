# OpenStack commands

```bash
# Delete disabled/down nova-compute node
nova service-delete <ID>
nova service-list
cinder reset-state --state available --attach-status detached VOLUME_ID
nova reset-state --active INSTANCE_ID
```
