# Useful commands: OpenStack

```text
Openstack Release: Stein
Installation Doc: https://docs.openstack.org/stein/install/
var/log/container/nova
tail -f /var/log/containers/nova/nova-* | ccze -A | grep ERROR
openstack server create --image IMAGE --flavor m1.tiny \
pssh -i -x "-t -t" -H heat-admin@c0 echo hi
add deployer key to heat-admin user full node
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7evBLX6lEo+QkzLDWDxN+DVtTKOpIticohsMMDfV9qNqz7sB5o71B4xlLQia/eMkyPtDTfXM/EVVLzr74knakJ2wc43X36y4WSI4c4XoX5xHxmwi8Imb2n0DTXlwsVhj6P920uUevmAKbCMNnePZ9/my92F4fMgjR9Ga1drtHSBFqfS657A8eEzYPvyQNt+tRomw/7Q2rIxWXZrqUhESfK+xBq2DUAVk2PFs9TJLcl0J9J3hj+5U6UT6y3JDSKlclyZkn7QQq1JJUd1d1O9ATVrzBv35V61lhXYfad7DNICSIL9PSH/2QXHIP4hmbMU6jDGrtOP/4CksBTUURZ8Qf root@overcloud-controller-0" >> .ssh/authorized_keys
    <name>`cat client.cinder.key`</name>
virsh secret-set-value --secret $(cat uuid-secret.txt) --base64 $(cat client.cinder.key) && rm client.cinder.key secret.xml
cat -n /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf | grep "^[^#;]" | grep enabled_backends
cat /var/lib/config-data/puppet-generated/glance_api/etc/glance/glance-api.conf | grep  -v '^\#' | grep -v '^$'
#hw_disk_bus=scsi: connect every cinder block devices to that controller
openstack image create --disk-format qcow2 --container-format bare --private --file /root/cirros/cirros-0.5.2-aarch64-disk.img cirros5
#source overcloudrc
cinder service-list
https://docs.openstack.org/keystone/pike/admin/identity-integrate-with-ldap.html
https://wiki.openstack.org/wiki/OpenLDAP#Ubuntu
vi /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone.conf
tar -zcvpf  /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone-$(date +"%Y_%m_%d_%I_%M_%p").tgz /var/lib/config-data/puppet-generated/keystone/etc/keystone/*
ldapadd -x -W -D"cn=admin,dc=openstack,dc=org" -f /tmp/openstack.ldif
docker restart keystone
nova boot --flavor 72d8e387-1e43-4340-8c2f-1d66d44255df --nic net-id=32f1bb6e-e538-4d2e-9e1c-c6ee16fda63b,v4-fixed-ip=192.168.1.14 --block-device source=volume,id=f255f9d4-3b8f-4f3a-ba2b-94e8651b8e3f,dest=volume,shutdown=preserve,bootindex=0 "DBook" --availability-zone nova:overcloud-novacompute-1.localdomain	
https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/backup_and_restore/04_overcloud_restore.html
grep "^[^#;]" /etc/nova/nova.conf | grep '\[vnc' -A 4
docker exec --user root -it nova_vnc_proxy bash
vi /etc/nova/nova.conf
docker exec -it nova_vnc_proxy grep "^[^#;]" /etc/nova/nova.conf | grep '\[vnc' -A 4
docker exec --user root -it nova_vnc_proxy vi /etc/nova/nova.conf
docker cp /root/noVNC-1.3.0/ nova_vnc_proxy:/media/noVNC-1.3.0/
https://docs.openstack.org/python-openstackclient/pike/cli/command-objects/complete.html
openstack baremetal node manage 10cb8b64-6a31-4f7d-af0f-e650ad3cea58
openstack baremetal node clean --clean-steps '[{"interface": "deploy", "step": "erase_devices_metadata"}]' 10cb8b64-6a31-4f7d-af0f-e650ad3cea58
openstack baremetal node set --property capabilities='node:-controller-0,boot_option:local,profile:control' 992d0cb2-30d7-4933-b653-86febac178fc
openstack baremetal node set --property capabilities='node:-compute-0,boot_option:local,profile:compute' 48872a34-0f20-45d7-a2e6-59faeaba2cb8
ironic node-update <id> replace properties/capabilities='node:controller-0,boot_option:local'
/usr/bin/python2 /bin/openstack overcloud deploy --templates /home/stack/generated-openstack-tripleo-heat-templates -e /home/stack/containers-prepare-parameter.yaml -e environment.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/services/octavia.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/docker-ha.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/network-isolation.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/network-environment.yaml -e /home/stack/templates/network-environment-overrides.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/services/neutron-ovn-dvr-ha.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/cinder-backup.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/services/ec2-api.yaml -e env_files/TimeZone_env.yaml -e env_files/Region_env.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/cinder-volume-active-active.yaml -e env_files/Octavia_env.yaml -e env_files/Enable_DVR_env.yaml -e env_files/hostnamemap.yaml -e env_files/ips-from-pool-all.yaml -e env_files/ips-from-pool-ctlplane.yaml --stack stackname   --overcloud-ssh-user heat-admin
openstack overcloud update prepare 
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/14
openstack overcloud delete stackname -y 
tar -zcvpf  /var/lib/mistral/overcloud/$(date +"%Y_%m_%d_%I_%M_%p").tgz /var/lib/mistral/overcloud/
nova boot --flavor 1f65f9c6-4fa9-405e-8cdd-210c651e984d --nic net-id=32f1bb6e-e538-4d2e-9e1c-c6ee16fda63b,v4-fixed-ip=192.168.1.14 --block-device source=volume,id=f255f9d4-3b8f-4f3a-ba2b-94e8651b8e3f,dest=volume,shutdown=preserve,bootindex=0 "DBook" --availability-zone nova:overcloud-novacompute-1.localdomain	
openstack volume create --size 8 --availability-zone nova test-final1
#overcloud installation failed:
## ssh heat-admin just using provision IP (source stackrc)
(undercloud) [stack@datacentername--undercloud ~]$ openstack server list
| 1a5485fc-0d11-42fe-be65-c778b4a91407 | overcloud-controller-1  | ACTIVE | ctlplane=172.41.202.108 | overcloud-full | control |
| 082ac7b9-80e4-4cfa-b743-f12f32ebd3cf | overcloud-controller-0  | ACTIVE | ctlplane=172.41.202.104 | overcloud-full | control |
| df6d62f8-7bb6-49dc-8e6d-476b0ec5149c | overcloud-controller-2  | ACTIVE | ctlplane=172.41.202.118 | overcloud-full | control |
| b0b9ed5c-ed52-4ec1-b86e-eea2978500a2 | overcloud-novacompute-0 | ACTIVE | ctlplane=172.41.202.121 | overcloud-full | compute |
https://github.com/openstack/tripleo-heat-templates/tree/master/environments
https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html
    overcloud-controller-0: -controller-1
    overcloud-controller-1: -controller-2
    overcloud-controller-2: -controller-3
    overcloud-novacompute-0: -compute-1
	'%stackname%-novacompute-0':-compute-1
sudo mv /var/lib/mistral/overcloud/tripleo-ansible-inventory.yaml /var/lib/mistral/overcloud/tripleo-ansible-inventory.yaml-bak
openstack catalog list
#openstack horizon dashboard customization
https://cloud.garr.it/support/kb/cloud/federated_auth/?highlight=openstack%20panel#hide-dashboard-panels
python /usr/share/openstack-dashboard/manage.py  collectstatic
python /usr/share/openstack-dashboard/manage.py runserver
static/app/core/core.module.js:      'horizon.app.core.workflow',
openstack volume qos create --consumer "front-end" \
openstack volume qos associate QOS_ID VOLUME_TYPE_NAME
cinder qos-disassociate-all <VOLUME_TYPE_ID>
openstack volume qos set <VOLUME_TYPE_ID> --property "read_iops_sec_max=40" --property "write_iops_sec_max=10000"
full cinder qos parameters:
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/14/html/storage_guide/ch-cinder#section-volume-retype
openstack volume qos unset 1762f550-7a14-4492-8dbb-4a64d27cfacb --property 'total_iops_sec'
openstack server list --all-projects --project VPS_mohsen110abbasi@gmail.com
instancesId= $(openstack server list --all-projects --project VPC_khalafzadeh@rcs.ir_1641210917.006553 | grep -vE "\+|ID"| cut -d '|' -f 2)
openstack server show $instancesId | grep volumes_attached -A 1
openstack volume create --os-project-id ac073d9e9ac24a8590a0b8e6d52acc3c  --size 512 --availability-zone nova freeUni-new
openstack volume set d1289a98-1461-4c4e-83b1-f531c7cf1c3c --bootable True
# save IPs, name nova-host and  flavor 
nova show <intance id> | grep delete_on_termination
nova show 7e382d07-017d-432b-8fdd-79d96a1e9fa8 | grep delete_on_termination
nova boot --flavor 241acbe3-3848-4c74-a97a-8d7e414ef1fa --nic net-id=79d5d81f-70a7-4f59-a157-82d71768ee4f,v4-fixed-ip=192.168.1.31 --block-device source=volume,id=38594c8b-3144-4f53-8133-91207a172c3d,dest=volume,shutdown=preserve,bootindex=0 "File Server" --availability-zone nova:md-business-compute-006-rack14.localdomain
for i in $(docker ps -q -f name=nova);do docker exec -it $i grep -r -A 5 \<iotune /etc/nova ;done
#########cinder nfs and isolated pool for datacentername san
https://docs.openstack.org/cinder/stein/configuration/block-storage/drivers/nfs-volume-driver.html
https://docs.openstack.org/cinder/latest/admin/nfs-backend.html
https://github.com/lanclin/OpenStack/wiki/Cinder-Volume-in-OpenStack-through-NFS
for i in {"15b23cad-9623-40cc-923e-43d82f4d3caa","0d67a5fb-9087-4ab2-b676-0f413c6c2f82"} ;do export id=$i && openstack project show $(nova show  $id | grep tenant_id |awk '{print $4}') | grep name | awk '{print $4}';done
openstack port set cf7f1a28-18a4-4f34-8141-b9c7fcaa65e5  --no-security-group
openstack port set cf7f1a28-18a4-4f34-8141-b9c7fcaa65e5  --disable-port-security
https://docs.openstack.org/neutron/stein/admin/config-qos.html
for i in $(virsh list --name) ;do echo $i && virsh dumpxml $i | grep nova:name&& virsh domblklist $i;done
for i in $(virsh list --name) ;do echo $i && virsh dumpxml $i | grep nova:name && virsh dumpxml $i | grep iotune -A 5&& virsh domblklist $i;done
https://docs.openstack.org/ocata/cli-reference/cinder.html
burst--> https://docs.openstack.org/cinder/latest/admin/basic-volume-qos.html
https://docs.openstack.org/cinder/stein/admin/blockstorage-manage-volumes.html
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html/storage_guide/ch-cinder
https://docs.openstack.org/networking-ovn/stein/admin/refarch/provider-networks.html
openstack server list --project VPC_Field -f value -c ID
openstack compute service delete 248
for i in $(openstack aggregate list -f json -c ID | jq .[] | jq -r .ID)
openstack compute service list -f json | jq .[] | jq '.ID'
nova interface-attach --port-id <port-id> <instance-id>
######## pattern suggested by Openstack: '^(?!(amq\.)|(.*_fanout_)|(reply_)).*'
openstack server migrate 227629fb-b189-4987-a47b-8125bb9eef62 --live datacentername-economy-compute-001-rack01.localdomain --wait
`openstack volume type set --property is_public='False' <volume-type>`
```