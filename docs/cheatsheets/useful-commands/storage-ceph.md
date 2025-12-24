# Useful commands: Storage and Ceph

```text
ceph installer VM
ceph installer VM network config
tar -zcvpf  /etc/ceph/ceph-$(date +"%Y_%m_%d_%I_%M_%p").tgz /etc/ceph/*
-------ceph deployer---------------------------------------------
ceph df
ceph osd lspools
ceph -s
ceph -v
------------------------------------------------------------------ ceph integration commands
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/4/html/block_device_to_openstack_guide/installing-and-configuring-ceph-for-openstack
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/4/html/block_device_to_openstack_guide/configuring-openstack-to-use-ceph-block-devices
ceph auth get-or-create client.cinder mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rwx pool=vms, allow rx pool=images'
ceph auth get-or-create client.cinder-backup mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=backups'
ceph auth get-or-create client.glance mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=images'
ceph auth get-or-create client.cinder | ssh c0 sudo tee /etc/ceph/ceph.client.cinder.keyring
ssh c0 chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder-backup | ssh c0 tee /etc/ceph/ceph.client.cinder-backup.keyring
ssh c0 chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring
ceph auth get-or-create client.glance | ssh c0 sudo tee /etc/ceph/ceph.client.glance.keyring
ssh c0 chown glance:glance /etc/ceph/ceph.client.glance.keyring
********************ceph auth caps client.ID mon 'allow r, allow command "osd blacklist"' osd 'EXISTING_OSD_USER_CAPS'
  <usage type='ceph'>
crudini --set /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf DEFAULT enabled_backends ceph2
ceph auth get-or-create client.glance | ssh GLANCE_API_NODE sudo tee /etc/ceph/ceph.client.glance.keyring
ssh GLANCE_API_NODE chown glance:glance /etc/ceph/ceph.client.glance.keyring
ceph auth get-or-create client.cinder > /etc/ceph/ceph.client.cinder.keyring
fdisk /dev/sdb
sudo mkfs -t ext4 /dev/sdb1
ceph auth get-or-create client.cinder | ssh c1 sudo tee /etc/ceph/ceph.client.cinder.keyring
ssh c1 chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder-backup | ssh c1 tee /etc/ceph/ceph.client.cinder-backup.keyring
ssh c1 chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring
ceph auth get-or-create client.glance | ssh c1 sudo tee /etc/ceph/ceph.client.glance.keyring
ssh c1 chown glance:glance /etc/ceph/ceph.client.glance.keyring
crudini --set /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf DEFAULT enabled_backends ceph
crudini --set /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf ceph rbd_secret_uuid 0d0fc4da-dad1-429e-915e-a42ff0f5af8b
crudini --set /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf ceph volume_backend_name ceph
Capacity-Derived QoS Limits:
rbd perf image iostat --pool volumes
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/4/html/troubleshooting_guide/troubleshooting-ceph-monitors
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/4/html-single/troubleshooting_guide/index#troubleshooting-networking-issues
rbd ls economy_volumes | grep d1289a98-1461-4c4e-83b1-f531c7cf1c3c
#rbd rm economy_volumes/volume-<enw volume>
rbd rm economy_volumes/volume-d1289a98-1461-4c4e-83b1-f531c7cf1c3c
#qemu-img convert -f raw -O raw rbd:economy_volumes/volume-<main volume> rbd:economy_volumes/volume-<new volume> -p
qemu-img convert -f raw -O raw rbd:economy_volumes/volume-e1ed7418-7a64-4840-b86b-12a994439300 rbd:economy_volumes/volume-d1289a98-1461-4c4e-83b1-f531c7cf1c3c -p
rbd lock ls economy_volumes/volume-5b368103-008c-4069-ae26-ec414e90e873
rbd lock rm economy_volumes/volume-5b368103-008c-4069-ae26-ec414e90e873 "auto 94440673370752" client.7608379
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/3/html/storage_strategies_guide/crush_administration
ceph osd dump | grep "^pool" | grep "crush_rule"
ceph osd crush rm-device-class osd.22OSD
ceph osd crush set-device-class ssd osd.22OSD
ceph device ls
ceph osd crush tree --show-shadow
resize2fs /dev/sda3
resize2fs /dev/ubuntu-vg/ubuntu-lv
ceph-volume lvm list
vgremove ceph-549c53af-d0a2-4cad-bfe6-b765d80aaebe
ceph-volume lvm create --osd-id 73 --data /dev/sdj
systemctl stop ceph\*.service ceph\*.target
rpm -qa|grep ceph-ansible
ceph osd pool set economy_volumes  crush_rule SSD
#ceph osd crush rule create-replicated SSD default~ssd host ssd
ceph auth caps client.cinder mon 'allow r, allow command "osd blacklist"' osd 'allow class-read object_prefix rbd_children, allow rwx pool=cinder-volumes, allow rx pool=glance-images, allow rwx pool=capacity'
ceph auth get-or-create client.cinder mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=capacity, allow rwx pool=economy_volumes, allow rx pool=glance_images' -o /etc/ceph/ceph.client.cinder.keyring
ceph osd crush set-device-class <class> <osdId> [<osdId>]
ceph osd crush rule create-replicated <rule-name> <root> host hdd
ceph osd pool set glance-images crush_rule ssd
ceph osd crush rule create-replicated HDD default host hdd
ceph auth caps client.cinder mon 'allow r, allow command "osd blacklist"' osd 'allow class-read object_prefix rbd_children, allow rwx pool=cinder-volumes, allow rx pool=glance-images, allow rwx pool=Capacity'
ceph osd pool application enable Capacity rbd
ceph osd pool create  Capacity 32 replicated HDD
ceph osd pool set Capacity pg_num 512
ceph osd pool set Capacity pgp_num 512
ceph osd pool set Capacity pg_autoscale_mode off
ceph osd pool get cinder-volumes  pg_num
ceph osd pool get cinder-volumes  pgp_num
ceph osd pool set Capacity size 1
###crush rule
##command usful when disk wont join to CEPH
ceph crash archive-all
fdisk /dev/sdg
vgremove cl
vgremove toodr
pvremove /dev/sdg2
vgremove cinder-volumes
cfdisk /dev/sd
service ceph-osd@16 stop
ceph-osd -i 81 --flush-journal
ceph osd purge osd.16 --force
vgremove -y ceph-f51bee92-f129-4143-bbad-283099970a4c
for i in `ceph osd tree | grep osd | grep -w up | awk '{print $4}'` ; do echo $i >> /opt/script/bench && ceph tell $i bench >> /opt/script/bench;done
cat /opt/script/bench | grep -E "osd|iops"
ceph osd status
ceph-volume lvm new-wal --osd-id 16 --osd-fsid 72abd754-c950-4c3e-a5d0-120016c0728e --target testWAL/testWAL
service ceph-osd@16 start
ls -lah /var/lib/ceph/osd/ceph-16/
cat /var/log/ceph/ceph-osd.16.log | grep wal
https://ceph.io/en/news/blog/2013/openstack-ceph-rbd-and-qos/
https://docs.openstack.org/cinder/stein/admin/blockstorage-capacity-based-qos.html
https://www.redhat.com/en/blog/ceph-block-performance-monitoring-putting-noisy-neighbors-their-place-rbd-top-and-qos
#create backup in backup2 from c3(ceph mon to access rbd)
qemu-img convert -p -O qcow2  rbd:Economy-cinder-volumes/volume-beab3381-7ad2-4831-82c1-70565bbc84c7 carpo-01.qcow2
qemu-img convert -p -O qcow2  rbd:Economy-cinder-volumes/volume-99504aff-26b0-4b17-9b01-3f0df32de2f3 carpo-02.qcow2
lvremove ceph-9d72340e-5305-4250-be0c-bec4c731535c/osd-block-4f7bb03a-6e7d-4c52-9cf8-f8e07f72e220 ceph-f9f93dca-3723-4331-9ec3-3606c613cfa4/osd-block-a7304a75-9e9e-487f-a14a-71a41a69d94c
pvremove /dev/sdb /dev/sdc /dev/sdd /dev/sde
vgremove ceph-345d800b-3817-4032-9f8d-abca7de475d5 ceph-3bb73c58-419f-4917-98fc-2f7f0dc699bc ceph-9d72340e-5305-4250-be0c-bec4c731535c ceph-f9f93dca-3723-4331-9ec3-3606c613cfa4
docker run -it --network=host --name ceph_client -v /Backup/:/Backup/ --restart=always ubuntu:focal
### gluster fs for Ceph disater backup from SAN [ref](https://docs.gluster.org/en/main/Quick-Start-Guide/Quickstart/#step-1-have-at-least-three-nodes)
    gluster volume create CephDisasterBackup disperse 6 redundancy 2 s14:/bricks/brick4/gv0 s14:/bricks/brick5/gv0 s14:/bricks/brick6/gv0 s15:/bricks/brick4/gv0 s15:/bricks/brick5/gv0 s15:/bricks/brick6/gv0 force
    gluster volume add-brick CephDisasterBackup s14:/bricks/brick19/gv0 s14:/bricks/brick20/gv0 s14:/bricks/brick21/gv0 s15:/bricks/brick19/gv0 s15:/bricks/brick20/gv0 s15:/bricks/brick21/gv0 force
    gluster volume add-brick CephDisasterBackup s14:/bricks/brick13/gv0 s14:/bricks/brick14/gv0 s14:/bricks/brick15/gv0 s15:/bricks/brick13/gv0 s15:/bricks/brick14/gv0 s15:/bricks/brick15/gv0 s14:/bricks/brick16/gv0 s14:/bricks/brick17/gv0 s14:/bricks/brick18/gv0 s15:/bricks/brick16/gv0 s15:/bricks/brick17/gv0 s15:/bricks/brick18/gv0 force
    gluster volume info gv0
    gluster volume rebalance gv0 start
    gluster volume rebalance gv0 status
    0 22 * * 3 /opt/scripts/CephDisasterBackup/eco/cron.sh >> "/opt/scripts/CephDisasterBackup/eco/CephDisasterBackup_$(date +"%F %T")".log
    0 22 * * 4 /opt/scripts/CephDisasterBackup/bus/cron.sh >> "/opt/scripts/CephDisasterBackup/bus/CephDisasterBackup_$(date +"%F %T")".log
    tmux new -d 'docker exec -it ceph_client bash "/opt/scripts/CephDisasterBackup/eco/eco-qemuDisasterBackup.sh" >>"/opt/scripts/CephDisasterBackup/eco/CephDisasterBackup_$(date +"%F %T")".log'
    docker exec -it ceph_client bash -c "/opt/scripts/CephDisasterBackup/bus/bus-qemuDisasterBackup" >>"/opt/scripts/CephDisasterBackup/bus/CephDisasterBackup_$(date +"%F %T")".log
```