# MikroTik edge router notes (RouterOS)

MikroTik installed on ESX; NIC teaming and VLAN tagging off-loaded on ESX vmxnet.

- Architecture: x86_64
- CPU: 16 cores
- RAM: 48 GB
- Snapshot: 2023-05-23 (RouterOS 7.9.1)

## Queue example
Repeat for all `/32` targets:
```text
/queue simple add limit-at=150M/150M max-limit=300M/300M name=11.0.0.11 priority=1/1 queue=default/default target=11.0.0.11/32
```

## Neighbor discovery
```text
/ip neighbor discovery-settings set discover-interface-list=none
```

## IP configuration
```text
/ip address add address=10.0.0.1/27 interface=ether1 network=10.0.0.1
/ip address add address=10.0.0.12/29 interface=ether1 network=10.0.0.12
/ip address add address=10.0.0.13/26 interface=ether1 network=10.0.0.13
```

## DNS
```text
/ip dns set servers=1.1.1.1
```

## Firewall trust list
```text
/ip firewall address-list add address=172.20.128.0/24 list=RouterTrust
/ip firewall address-list add address=10.0.0.11/27 list=RouterTrust
/ip firewall address-list add address=10.0.0.12 list=RouterTrust
/ip firewall address-list add address=10.0.0.13 comment="Site" list=RouterTrust
/ip firewall filter add action=drop chain=input src-address-list=!RouterTrust
```

## FastTrack
```text
/ip firewall filter add action=fasttrack-connection chain=forward comment=FastTrack connection-state=established,related hw-offload=yes
/ip firewall filter add action=accept chain=forward comment="Established, Related" connection-state=established,related
/ip firewall filter add action=drop chain=forward comment="Drop invalid" connection-state=invalid log=yes log-prefix=invalid
```

## Default gateway
```text
/ip route add disabled=no dst-address=0.0.0.0/0 gateway=10.0.0.1
```

## IP services (Winbox + REST API)
```text
/ip service set telnet disabled=yes
/ip service set ftp disabled=yes
/ip service set www address=10.0.0.12/32,10.0.0.13/32
/ip service set ssh disabled=yes
/ip service set api disabled=yes
/ip service set winbox address=10.0.0.12/32,10.0.0.13/32
/ip service set api-ssl disabled=yes
```

## Time
```text
/system clock set time-zone-name=Con/Con
/system ntp client set enabled=yes
/system ntp client servers add address=[3.xxxx.pool.ntp.org]
/system ntp client servers add address=[1.xxxx.pool.ntp.org]
```

## Hardware
```text
/system hardware set allow-x86-64=yes
```

## Disable bandwidth test
```text
/tool bandwidth-server set authenticate=no enabled=no
```

## Disable MAC discovery/ping
```text
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
```

## REST API examples
Export bytes used by a queue:
```bash
curl -u admin:PASSWORD -X POST http://10.0.0.10/rest/queue/simple/print \
  --data '{".proplist":["target","bytes"], ".query": ["name=11.0.0.11"]}' \
  -H "content-type: application/json"
```

Export bytes for all queues:
```bash
curl -u admin:PASSWORD -X POST http://10.0.0.10/rest/queue/simple/print \
  --data '{".proplist":["target","bytes"]}' -H "content-type: application/json"
```

Reset queue by name:
```bash
curl -u admin:PASSWORD -X POST http://10.0.0.10/rest/queue/simple/reset-counters \
  --data '{"numbers": "11.0.0.11"}' -H "content-type: application/json"
```

Reset all counters:
```bash
curl -u admin:PASSWORD -X POST http://10.0.0.10/rest/queue/simple/reset-counters-all -H "content-type: application/json"
```

API ref: https://help.mikrotik.com/docs/display/ROS/REST+API
