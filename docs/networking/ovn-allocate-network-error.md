# OVN AllocateNetworkError notes

## Useful commands
```bash
ovs-vsctl remove Bridge br-int other_config overflow_policy
ovs-vsctl get Bridge br-int other_config:idle_timeout
ovs-appctl dpctl/show | grep flows | grep -v PMD
ovs-vswitchd --version
ovs-vsctl list-ifaces br-int
ovs-appctl dpctl/show
ovs-vsctl list interface
ovs-appctl dpctl/show ovn-d8da89-0
ovs-ofctl dump-flows br-int
ovs-ofctl dump-ports-desc br-int
ovs-ofctl dump-ports br-int
ovs-vsctl set Bridge br-int other_config:overflow_policy=evict
ovs-vsctl get Bridge br-int other_config:overflow_policy
ovs-vsctl remove Bridge br-int other_config overflow_policy
ovs-vsctl set Bridge br-int other_config:max-idle=30000
ovs-vsctl get Bridge br-int other_config:overflow_policy
sudo ovn-sbctl -- --id=@ls --id=@p -- --columns=name,external_ids,ports find Logical_Switch name=52fc2ecf-b204-49cf-b52c-c17ff408697b -- --columns=chassis,external_ids find Logical_Switch_Port ls=@ls name=52fc2ecf-b204-49cf-b52c-c17ff408697b -- --columns=name,mac find Port_Binding logical_port=@p
```

## Log excerpts
```text
2023-06-03 13:29:30.850 42 WARNING networking_ovn.ml2.mech_driver [req-1c909612-1bf8-4489-8834-129401863357 - - - - -] Logical port ca134f08-8816-4153-b924-b90a44390d90 is not bound to a chassis

2023-06-03 13:29:51.788 30 INFO neutron.pecan_wsgi.hooks.translation [req-900d91c4-1697-472e-aa45-bbab1354ca31 2d6688cd05d1463a91ddf3ec4fbc5d3c c73bad97900b446ebe2780a6453eb2d6 - default default] GET failed (client error): The resource could not be found

2023-06-03 13:29:45.193 30 INFO neutron.api.v2.resource [req-f6f4f3cd-5b03-46c8-bc4e-117df942b19e a08294e6587a4db3b4d00e59a3ad5d21 b0593f9d7d8b4942b244072b64091f18 - default default] show failed (client error): The resource could not be found

2023-06-03 13:39:34.279 29 WARNING neutron.api.rpc.agentnotifiers.dhcp_rpc_agent_api [req-efcdade9-b589-48eb-aae0-1b5689e86943 0a13dc5cd5a411ec98de0242ac1a0002 2c25113ddfdb4ec2a56b7aed12647801 - default default] Unable to schedule network e134ba9d-0187-4cfe-b42e-29368826cef5: no agents available; will retry on subsequent port and subnet creation events
```
