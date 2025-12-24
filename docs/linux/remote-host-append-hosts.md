# Remote host: append entries to /etc/hosts

Backup the file and append entries across multiple hosts:

```bash
for i in c0 c1 c2 e0 e1 e2 e3 e4 e5 e7 b1 b2 b3 b4 b5; do
  ssh $i cp /etc/hosts /etc/hosts-1-30-2023
  cat <<EOF | ssh $i 'cat - >> /etc/hosts'
172.20.120.131 overcloud-novacompute-9.localdomain overcloud-novacompute-9`
172.20.123.131 overcloud-novacompute-9.storage.localdomain overcloud-novacompute-9.storage ste5
172.20.124.131 overcloud-novacompute-9.storagemgmt.localdomain overcloud-novacompute-9.storagemgmt
172.20.120.131 overcloud-novacompute-9.internalapi.localdomain overcloud-novacompute-9.internalapi
172.20.122.131 overcloud-novacompute-9.tenant.localdomain overcloud-novacompute-9.tenant
172.20.128.131 overcloud-novacompute-9.ctlplane.localdomain overcloud-novacompute-9.ctlplane e9
86.104.44.221 overcloud-novacompute-9.external.localdomain overcloud-novacompute-9.external
EOF
done
```
