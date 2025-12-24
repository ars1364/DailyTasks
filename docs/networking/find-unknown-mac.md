# Find unknown MAC address in the network

Switch (Nexus 5000):
```text
show mac address-table | include e007.1bf1.0934
```

OpenStack (admin):
```bash
openstack port list --long
```

Horizon:
`/dashboard/admin/networks/ports`

Check vendor:
`https://macaddress.io/mac-address-lookup`

Check on all nodes:
```bash
for i in c{1..3} e{1..9} b{1..5}; do
  echo $i && timeout 5 ssh $i ip a | grep e0:07:1b:f1:09:34
done
```

Other options:
- `arp -a`
- `nmap -sn 172.20.120.10/24`
