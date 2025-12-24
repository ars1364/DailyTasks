# Useful commands (raw notes)

Raw notes from the old wiki, kept as-is. See other docs for curated runbooks.

```text

#add route to vpn provider  while using vpn (with -p command make it permanant- windows cmd )
route add 31.7.74.0 mask 255.255.255.0 192.168.1.1
route delete 31.7.74.0 mask 255.255.255.0 192.168.1.1
# VPN route issue
#uncheck use default gateway(VPN connection peroperties)
#run command prompt as administrator
route add 172.17.0.0 mask 255.255.0.0 172.16.246.1 -p

tracert -d 94.182.189.173
route add 94.182.189.173 mask 255.255.255.255 192.168.1.1 -p
route print
ln (create hard symbol link) -s (make soft one)
ls -ld (/etc/resolv.conf) (show the source file for symbol links)
:%s/pattern//ng
tmux
ctrl+B D
:setw synchronize-panes off
:setw synchronize-panes on
tmux new -s ahmad
tmux att -t ahmad
scroll up: ctrl+b pageUp or PageDown
ctrl+s (search) n next and N prev
ctrl+b ? man page
ctrl+s (show pane list)
#complex search and draw graph for log:
grep "desiredText" fileName | cut -d "text" -f2| sort | uniq -c | awk {print $2 " " $1 | termgraph
dmesg -n 1
dmesg -c
watch dmesg
#check rx tx for ethernet  error network 
watch -d -n 0.5 "ip -s link | grep -E 'eth12|eth11' -A 5"
/sys/class/net/eth11/rx_handler
/sys/class/net/eth11/tx_handler
-YZ4
virt-mgr
Openstack Release: Stein
Installation Doc: https://docs.openstack.org/stein/install/
#short curl http response
curl --write-out "%{http_code}\n" --silent --output /dev/null "$digikala.com"
#real user password for famous site like HP.com
bugmenot.com
#install ubuntu on windows using power shell(run as administrator)
wsl --install -d ubuntu
#run multi remote desktop access 
install windows server feature--> remote desktop service tools--> remote desktop session host
#connect to iLO ip using ssh and putty --> try to ping other IP in network
hp ilo cli --> oemhp_ping 1.1.1.1
#disk utility and speed benchmark
dd
fio
#log file
var/log/container/nova
tail -f /var/log/containers/nova/nova-* | ccze -A | grep ERROR
os dmesg
/var/log/docker
Ctrl+A or Home: Go to the beginning of the line.
Ctrl+E or End: Go to the end of the line.
Alt+B: Go left (back) one word.
Ctrl+B: Go left (back) one character.
Alt+F: Go right (forward) one word.
#########
db problem
controller1 docker  php my admin
controller1 docker mariadb --> .myini --> root password
panel valid ip -->root --> pass from .myini file
default port didnt work--> disable iptable
search for server id and edit it 
#####useful .sh file datacentername -- list instance in all host .sh file
#runcommand folder
lshw -c network | grep -i 10g -C 6
#####
openstack server create --image IMAGE --flavor m1.tiny \
  --nic net-id=UUID SERVER
#bonding
cat /proc/net/bonding/bond0
pfsens version-->2.4.5
2,400,000 fragment enteries
maxmind need license
shatlle sample
#tshark tcpdump dmesg last x minutes logs
tcpdump -G 1 -W 1 -w file.dump -D 
tcpdump -G 1 -W 1 -w file.dump -i bond0
journalctl -kS -1min > dmesg.dmp
yum install libpcap
yum install -y wireshark
touch tshark-output.pcap
chmod o=rw tshark-output.pcap
tshark -a duration:1 -i bond0 -w tshark-output.pcap -F libpcap
tshark -r tshark-output.pcap -V 
ls -lhrt
watch -d "dmesg|grep martian|cut -d ' ' -f 7|sort|uniq -c"
ip -br a | awk '{print $3}'| grep 172 | cut -d '/' -f 1
lshw -class network -short
pssh -i -x "-t -t" -H heat-admin@c0 echo hi
nmcli
nmtui
/etc/os-net-confif/config.json
os-net-config -c config.json
dhclient -r
#release
cssh
lspci -nnn | grep -i ethernet
lspci -vt
#resolve IP to host - if get NXDOMAIN error using host <ip> It's controller VIP 
nmap -o <ip>
cd /etc/sysconfig/network-scripts/
grep -rnw /etc/sysconfig/network-scripts/ -e 'bond0'
h=$(ls /etc/sysconfig/network-scripts/| grep bond0)
scp $h e0:/etc/sysconfig/network-scripts/
scp $h e1:/etc/sysconfig/network-scripts/
scp $h e2:/etc/sysconfig/network-scripts/
scp $h c0:/etc/sysconfig/network-scripts/
scp $h c1:/etc/sysconfig/network-scripts/
scp $h c2:/etc/sysconfig/network-scripts/
h=$(ls /etc/sysconfig/network-scripts/| grep br)
echo -e "DEVICE=bond0\nNAME=bond0\nTYPE=Bond\nBONDING_MASTER=yes\nONBOOT=yes\nBOOTPROTO=none\nBONDING_OPTS="mode=4 miimon=100 lacp_rate=1 xmit_hash_policy=2"\nHOTPLUG=yes\nNM_CONTROLLED=no" > ifcfg-bond0
sed -i "s/172.20.120.5/172.20.120.90/g" /etc/sysconfig/network-scripts/ifcfg-br120
tar -zcvpf  /etc/sysconfig/network-scripts/network-back.tgz /etc/sysconfig/network-scripts/*
h=$( ip -br a | awk '{print $3}'| grep 172 | cut -d '/' -f 1)
c=$(ls /etc/sysconfig/network-scripts/ | grep -E 'br|bond0')
echo '#'$h > /etc/sysconfig/network-scripts/$c
for i in $c;do echo '#'$h >> /etc/sysconfig/network-scripts/$i;done
s="[IP] 192.168.1.0"
ip="192.168.15.24"
sed -i "s/^\[IP] .*/[IP] $ip/" hello.txt
scp $(ls  | grep -E 'bond0|br') c2:/etc/sysconfig/network-scripts/
/var/lib/config-data/puppet-generated
grep -rnw 172 | wc -l
sed "s/20/20/g" $(ls|grep 'ifcfg-bond0.2')
cat /proc/net/vlan
cat /proc/net/bonding/bon0 | grep Permanent
add undercloud key to all hosts -- done
undercloud network config
controller network config
compute network config
network bridge ovs
update kernel
ceph installer VM
ceph installer VM network config
add deployer key to heat-admin user full node
test network through switch
test vlan 124,126 from deployer VM
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:1b:21:bc:bb:00", ATTR{type}=="1", KERNEL=="eth*"  NAME="eth3"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:1b:21:bc:bb:01", ATTR{type}=="1", KERNEL=="eth*"  NAME="eth4"
ip -br a
ifconfig -a | grep eth
vi /etc/ssh/sshd_config
PasswordAuthentication yes
ChallengeResponseAuthentication yes
systemctl restart sshd
ssh-copy-id -i .ssh/id_rsa.pub root@172.20.123.170
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7evBLX6lEo+QkzLDWDxN+DVtTKOpIticohsMMDfV9qNqz7sB5o71B4xlLQia/eMkyPtDTfXM/EVVLzr74knakJ2wc43X36y4WSI4c4XoX5xHxmwi8Imb2n0DTXlwsVhj6P920uUevmAKbCMNnePZ9/my92F4fMgjR9Ga1drtHSBFqfS657A8eEzYPvyQNt+tRomw/7Q2rIxWXZrqUhESfK+xBq2DUAVk2PFs9TJLcl0J9J3hj+5U6UT6y3JDSKlclyZkn7QQq1JJUd1d1O9ATVrzBv35V61lhXYfad7DNICSIL9PSH/2QXHIP4hmbMU6jDGrtOP/4CksBTUURZ8Qf root@overcloud-controller-0" >> .ssh/authorized_keys
ssh-keyscan -t ecdsa 172.20.123.172 >> ~/.ssh/known_hosts
ssh-keygen -R 5
ssh-keygen -R 172.20.128.25
tar -zcvpf  /etc/sysconfig/network-scripts/network-bak-$(date +"%Y_%m_%d_%I_%M_%p").tgz /etc/sysconfig/network-scripts/*
tar -zcvpf  /etc/ceph/ceph-$(date +"%Y_%m_%d_%I_%M_%p").tgz /etc/ceph/*
tar -zcvpf  /etc/hosts-$(date +"%Y_%m_%d_%I_%M_%p").tgz /etc/hosts
grep -rnw IPADDR /etc/sysconfig/network-scripts/ifcfg-*
for i in $(ls | grep ifcfg-bond0); do sed -r 's/^IPADDR=172.20.120.*/IPADDR=172.20.120.$lastoctect/g' $i;done
#remove all lines started with number sign in vi editor
:g/^\$/d
:g/^\#/d
#remove all blank lines in vi editor
:g/^$/d
lastoctet=$'172'
echo $lastoctet
##########test and verify
sed -r  "s/^IPADDR=172.20.120.*/IPADDR=172.20.120.$lastoctet/g" ifcfg-bond0.20 && \
sed -r  "s/^IPADDR=172.20.122.*/IPADDR=172.20.122.$lastoctet/g" ifcfg-bond0.22 && \
sed -r  "s/^IPADDR=172.20.124.*/IPADDR=172.20.124.$lastoctet/g" ifcfg-bond0.24 && \
sed -r  "s/^IPADDR=172.20.126.*/IPADDR=172.20.126.$lastoctet/g" ifcfg-bond0.26 && \
sed -r  "s/^IPADDR=172.20.128.*/IPADDR=172.20.128.$lastoctet/g" ifcfg-bond0.28 && \
sed -r  "s/^IPADDR=172.20.123.*/IPADDR=172.20.123.$lastoctet/g" ifcfg-br-ex
############make sure then use i to write in the file##############
sed -ri  "s/^IPADDR=172.20.120.*/IPADDR=172.20.120.$lastoctet/g" ifcfg-bond0.20 && \
sed -ri  "s/^IPADDR=172.20.122.*/IPADDR=172.20.122.$lastoctet/g" ifcfg-bond0.22 && \
sed -ri  "s/^IPADDR=172.20.124.*/IPADDR=172.20.124.$lastoctet/g" ifcfg-bond0.24 && \
sed -ri  "s/^IPADDR=172.20.126.*/IPADDR=172.20.126.$lastoctet/g" ifcfg-bond0.26 && \
sed -ri  "s/^IPADDR=172.20.128.*/IPADDR=172.20.128.$lastoctet/g" ifcfg-bond0.28 && \
sed -ri  "s/^IPADDR=172.20.123.*/IPADDR=172.20.123.$lastoctet/g" ifcfg-br-ex
iptables -F
iptables -L -n -v
systemctl stop iptables
systemctl status iptables
systemctl disable iptables
systemctl mask --now iptables
echo -e "; generated by /usr/sbin/dhclient-script\nsearch localdomain\nnameserver 178.22.122.100\nnameserver 185.51.200.2\n" > /etc/resolv.conf
echo -e "; generated by /usr/sbin/dhclient-script\n" > ifcfg-bond0
ip link show type bond_slave
ip -details link show dev <ovs-system>
ip link show type openvswitch
The interface virbr0-nic is not a bridge, but a normal ethernet interface (although a virtual one, created with ip add type (https://man7.org/linux/man-pages/man4/veth.4.html)).
It's there so that the bridge has at least one interface beneath it to steal it's mac address from. It passes no real traffic, since it's not really connected to any physical device.
The bridge would work without it, but then it could change it's mac address as interfaces enter and exit the bridge, and when the mac of the bridge changes, external switches may be confused, making the host lose network for some time.
-------ceph deployer---------------------------------------------
    <interface type='bridge'>
      <mac address='52:54:00:e2:b8:df'/>
      <source bridge='br123'/>
      <virtualport type='openvswitch'>
        <parameters interfaceid='b78ef61a-aafd-4c15-949f-7912afa1e384'/>
      </virtualport>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>
      <mac address='52:54:00:7e:58:60'/>
      <source bridge='br124'/>
        <parameters interfaceid='7ebbf175-e8ed-4b00-8f67-bfd9eee72433'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x0'/>
      <mac address='52:54:00:4b:1f:77'/>
      <source bridge='br126'/>
        <parameters interfaceid='192ae0af-b5db-4a4f-b64d-87dbb3a3e90d'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
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
#run on all controller
ceph auth get-or-create client.cinder | ssh c0 sudo tee /etc/ceph/ceph.client.cinder.keyring
ssh c0 chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder-backup | ssh c0 tee /etc/ceph/ceph.client.cinder-backup.keyring
ssh c0 chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring
ceph auth get-or-create client.glance | ssh c0 sudo tee /etc/ceph/ceph.client.glance.keyring
ssh c0 chown glance:glance /etc/ceph/ceph.client.glance.keyring
********************ceph auth caps client.ID mon 'allow r, allow command "osd blacklist"' osd 'EXISTING_OSD_USER_CAPS'
cat > secret.xml <<EOF
<secret ephemeral='no' private='no'>
  <uuid>`cat uuid-secret.txt`</uuid>
  <usage type='ceph'>
    <name>`cat client.cinder.key`</name>
  </usage>
</secret>
EOF
  <uuid>81cc21ab-1d51-470f-ae3b-f5972166ea60</uuid>
    <name>AQC1G8Bifi7UBxAAQYptFDJGH2GyOcAY1Bd2Uw==</name>
virsh secret-define --file secret.xml
virsh secret-set-value --secret $(cat uuid-secret.txt) --base64 $(cat client.cinder.key) && rm client.cinder.key secret.xml
cat -n /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf | grep "^[^#;]" | grep enabled_backends
#all lines except blank and commented ones
cat /var/lib/config-data/puppet-generated/glance_api/etc/glance/glance-api.conf | grep  -v '^\#' | grep -v '^$'
crudini --set /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf DEFAULT enabled_backends ceph2
#hw_scsi_model=virtio-scsi: add the virtio-scsi controller and get better performance and support for discard operation
#hw_disk_bus=scsi: connect every cinder block devices to that controller
#hw_qemu_guest_agent=yes: enable the QEMU guest agent
#os_require_quiesce=yes: send fs-freeze/thaw calls through the QEMU guest agent
docker restart $(docker ps -a -q)
openstack image create --disk-format qcow2 --container-format bare --private --file /root/cirros/cirros-0.5.2-aarch64-disk.img cirros5
ceph auth get-or-create client.glance | ssh GLANCE_API_NODE sudo tee /etc/ceph/ceph.client.glance.keyring
ssh GLANCE_API_NODE chown glance:glance /etc/ceph/ceph.client.glance.keyring
#all controller
ceph auth get-or-create client.cinder > /etc/ceph/ceph.client.cinder.keyring
#source overcloudrc
cinder service-list
############################
ubuntu 18 on undercloud
br120
br123
copy image to /var/lib/libvirt/images/
CPU 4
RAM 4096MB
Disk 20 GB
ifconfig ens3 172.20.123.7/24
route add default gw 172.20.123.250
systemctl stop ufw
systemctl disable ufw
add NIC one by one to machine using virt-manager
shut down LDAP machine, apply network config using virsh edit then start and config IP either netplan() as permanent way or ifconfig as temp way
#ubuntu machine usefull config
vim /etc/netplan/00-installer-config.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eno1:
     dhcp4: no
    eno2:
  bonds:
      bond0:
          dhcp4: no
          interfaces:
              - eno1
              - eno2
          parameters:
              mode: 802.3ad
              mii-monitor-interval: 100
  vlans:
     bond0.1709:
          id: 1709
          link: bond0
          addresses: [ "172.20.128.8/24" ]
     bond0.1710:
          id: 1710
          addresses: [ "31.7.67.252/24" ]
          gateway4: 31.7.67.1
          nameservers:
              addresses: [ "1.1.1.1" ]
netplan apply
ip link set ens9 down
ip link set ens9 up
	#UsePAM yes
	PasswordAuthentication yes
	ChallengeResponseAuthentication yes
	PermitRootLogin yes
service sshd restart
##how to find service names
systemctl list-unit-files | grep -i network
###change default mirror ubuntu respository
nano /etc/apt/sources.list
sed -E -i 's#http://[^\s]*archive\.ubuntu\.com/ubuntu#http://be.archive.ubuntu.com/ubuntu#g' /etc/apt/sources.list
login page:
http://172.20.123.7/phpldapadmin
sample username:
cn=admin,dc=stage,dc=local
https://docs.openstack.org/keystone/pike/admin/identity-integrate-with-ldap.html
https://wiki.openstack.org/wiki/OpenLDAP#Ubuntu
vi /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone.conf
tar -zcvpf  /var/lib/config-data/puppet-generated/keystone/etc/keystone/keystone-$(date +"%Y_%m_%d_%I_%M_%p").tgz /var/lib/config-data/puppet-generated/keystone/etc/keystone/*
ss -tulpn | grep slapd
nmap -sP 389 172.20.123.7
#for test run on ldap node
ldapsearch -x -W -D"cn=admin,dc=stage,dc=local" -b dc=stage,dc=local }}
ldapsearch -x -W -D"cn=admin,dc=stage,dc=local" -b dc=stage,dc=local }} -H ldap://172.20.123.7
#find users' password 
cat /var/lib/config-data/puppet-generated/placement/etc/placement/placement.conf | grep pymysql
#create file as described in this doc
#when u done Then add that file to ldap by issuing the following command
ldapadd -x -W -D"cn=admin,dc=openstack,dc=org" -f /tmp/openstack.ldif
docker restart keystone
#######################################
tar -tvf  /etc/sysconfig/network-scripts/network-back.tgz | grep eth
#############pfsense
docker run -v ${PWD}/reports:/app/reports wallarm/gotestwaf --grpcPort 9000 --url=https://xx.ir
docker build . --force-rm -t gotestwaf
docker run -v /tmp:/tmp/report gotestwaf --url=https://
docker run -v ${PWD}/reports:/app/reports --network="host" \
    wallarm/gotestwaf --url=https://xx.ir
not necessary pfsense package:
darkstate
iperf
	lacp 8023ad
shattle Virtual IP description:
94.182.156.60/32 nat VPC
192.20.120.1/21 nat VPC
#############################
nova boot --flavor 72d8e387-1e43-4340-8c2f-1d66d44255df --nic net-id=32f1bb6e-e538-4d2e-9e1c-c6ee16fda63b,v4-fixed-ip=192.168.1.14 --block-device source=volume,id=f255f9d4-3b8f-4f3a-ba2b-94e8651b8e3f,dest=volume,shutdown=preserve,bootindex=0 "DBook" --availability-zone nova:overcloud-novacompute-1.localdomain	
ipmitool -I lanplus -H 10.43.138.12 -L ADMINISTRATOR -p 6320 -U admin -R 3 -N 5 -P redhat power status
###########bime barekat
31.7.65.209
Xa@Sadmin
terminal=export file=filename
strong swan
###galera t-shoo pcs resource
pcs resource manage galera-bundle
pcs resource cleanup galera-bundle
MYSQLIP=$(grep -A1 'listen mysql' /var/lib/config-data/haproxy/etc/haproxy/haproxy.cfg | grep bind | awk '{print $2}' | awk -F":" '{print $1}')
https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/backup_and_restore/04_overcloud_restore.html
#ssh tunneling
ssh -R 3333:127.0.0.1:22 root@31.7.74.25 -YC4
ssh root@127.0.0.1 -p 3333
################NoVNC Upgrade
https://ilearnedhowto.wordpress.com/tag/novnc/
grep "^[^#;]" /etc/nova/nova.conf | grep '\[vnc' -A 4
datacentername:
docker exec --user root -it nova_vnc_proxy bash
vi /etc/nova/nova.conf
awk '$1 ~ /^[^;#]/' FILE.conf
novncproxy_base_url = https://79.127.117.114:6080/vnc_lite.html
docker exec -it nova_vnc_proxy grep "^[^#;]" /etc/nova/nova.conf | grep '\[vnc' -A 4
docker exec --user root -it nova_vnc_proxy vi /etc/nova/nova.conf
curl -v http://79.127.117.114:6080//yahoo.com/%2F..
curl -v --insecure -I http://79.127.117.114:6080//yahoo.com/%2F..
--insecure -I
wget https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz -O novnc-v1.1.3.tar.gz
tar xfz novnc-v1.1.3.tar.gz
docker cp /root/noVNC-1.3.0/ nova_vnc_proxy:/media/noVNC-1.3.0/
mv /usr/share/novnc /usr/share/novnc-bak2
mv /media/noVNC-1.3.0/ /usr/share/novnc
cd /usr/share/novnc
mv vnc_lite.html vnc_auto.html
#################### apache 2 
https://www.digitalocean.com/community/tutorials/how-to-rewrite-urls-with-mod_rewrite-for-apache-on-ubuntu-16-04
RewriteEngine on
RewriteRule !^vnc_lite\.html vnc_lite.html [F,NC]
#datacentername vlaning 
ctl-plane = provision
datacentername provision = vlan202
datacentername accesss provision = NC1P4
datacentername trunk = NC1P1
#bash completion
https://www.tecmint.com/install-and-enable-bash-auto-completion-in-centos-rhel/
https://docs.openstack.org/python-openstackclient/pike/cli/command-objects/complete.html
openstack baremetal node manage 10cb8b64-6a31-4f7d-af0f-e650ad3cea58
openstack baremetal node clean --clean-steps '[{"interface": "deploy", "step": "erase_devices_metadata"}]' 10cb8b64-6a31-4f7d-af0f-e650ad3cea58
fdisk /dev/sdb
n
2
def
w
sudo mkfs -t ext4 /dev/sdb1
openstack baremetal node set --property capabilities='node:-controller-0,boot_option:local,profile:control' 992d0cb2-30d7-4933-b653-86febac178fc
openstack baremetal node set --property capabilities='node:-compute-0,boot_option:local,profile:compute' 48872a34-0f20-45d7-a2e6-59faeaba2cb8
ironic node-update <id> replace properties/capabilities='node:controller-0,boot_option:local'
/usr/bin/python2 /bin/openstack overcloud deploy --templates /home/stack/generated-openstack-tripleo-heat-templates -e /home/stack/containers-prepare-parameter.yaml -e environment.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/services/octavia.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/docker-ha.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/network-isolation.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/network-environment.yaml -e /home/stack/templates/network-environment-overrides.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/services/neutron-ovn-dvr-ha.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/cinder-backup.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/services/ec2-api.yaml -e env_files/TimeZone_env.yaml -e env_files/Region_env.yaml -e /home/stack/generated-openstack-tripleo-heat-templates/environments/cinder-volume-active-active.yaml -e env_files/Octavia_env.yaml -e env_files/Enable_DVR_env.yaml -e env_files/hostnamemap.yaml -e env_files/ips-from-pool-all.yaml -e env_files/ips-from-pool-ctlplane.yaml --stack stackname   --overcloud-ssh-user heat-admin
openstack overcloud update prepare 
--dry-run  
--validation-errors-nonfatal
main redhat doc:
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/14

openstack overcloud delete stackname -y 
rm .ssh/known_hosts
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjchz5wm/03z4vuULMMarO1b4U1U6oGJ721JXEcShBGtA8qXDXdfDYhohZWBBxzp0MC8ErZ5qKFE2cXJtGKH7SvxlUPLlEU9JYlfIkzGqMIc13qcZqUJVjgIRjcfC3BQx6Ht5FpIMpV7w6rMwzdqrTLvyhFDSIz8e22QetITR848sYnKWvn/hp6pupRL2mmaj9rKIOhBjyOC0p5azy/Ch5BtKOifRTG0jjpPw7tCKpahW5VCUt0aaFwXN6o5GzHj8Cb92rAkX2Pqr0sObUqqi5/WMtE+CY3JxxeIAwcVOscs3LNstROA3tDmk4/pfPfB9VTx4D4LUeYQ9iIw2WpcyB root@stage-udnercloud.localdomain
tar -zcvpf  /var/lib/mistral/overcloud/$(date +"%Y_%m_%d_%I_%M_%p").tgz /var/lib/mistral/overcloud/
nmap -T4 -A -v 172.41.203.21
iptables-save > /root/controller3.fw
iptables-restore < /root/dsl.fw
ceph auth get-or-create client.cinder | ssh c1 sudo tee /etc/ceph/ceph.client.cinder.keyring
ssh c1 chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder-backup | ssh c1 tee /etc/ceph/ceph.client.cinder-backup.keyring
ssh c1 chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring
ceph auth get-or-create client.glance | ssh c1 sudo tee /etc/ceph/ceph.client.glance.keyring
ssh c1 chown glance:glance /etc/ceph/ceph.client.glance.keyring
crudini --set /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf DEFAULT enabled_backends ceph
crudini --set /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf ceph rbd_secret_uuid 0d0fc4da-dad1-429e-915e-a42ff0f5af8b
crudini --set /var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf ceph volume_backend_name ceph
nova boot --flavor 1f65f9c6-4fa9-405e-8cdd-210c651e984d --nic net-id=32f1bb6e-e538-4d2e-9e1c-c6ee16fda63b,v4-fixed-ip=192.168.1.14 --block-device source=volume,id=f255f9d4-3b8f-4f3a-ba2b-94e8651b8e3f,dest=volume,shutdown=preserve,bootindex=0 "DBook" --availability-zone nova:overcloud-novacompute-1.localdomain	
openstack volume create --size 8 --availability-zone nova test-final1
ssh -R 3333:127.0.0.1:22 root@31.7.75.99 -YC4
#overcloud installation failed:
connection timeout to specific node-->check connectivity potential issue and retry
shecan failed--> check docker.io ping banned website like bbc.com then retry
No IPs found for Compute role on ctlplane network--> check connection over provisioning vlan(access provisioning-->ctlplane) to all nodes, check switch config or boot server using slax and set manual IP and check connection to ensure
403 Client Error: Forbidden for url: https://registry-1.docker.io/v2/
sudo podman login registry.platform.xaas.ir
curl http://172.41.202.10:8787/v2/_catalog?n=150 | jq .repositories[]
https://dns.sb/guide/doh/linux/#_2-connect-dns-sb-doh-server
dnsproxy -l 127.0.0.1 -p 53 -u free.shecan.ir -b 185.51.200.2:53
sudo podman login -u <User> -p <pass> https://registry-1.docker.io/v2/
dig https://registry-1.docker.io/v2/
sudo podman login  https://registry.platform.xaas.ir
## ssh heat-admin just using provision IP (source stackrc)
(undercloud) [stack@datacentername--undercloud ~]$ openstack server list
+--------------------------------------+-------------------------+--------+-------------------------+----------------+---------+
| ID                                   | Name                    | Status | Networks                | Image          | Flavor  |
| 1a5485fc-0d11-42fe-be65-c778b4a91407 | overcloud-controller-1  | ACTIVE | ctlplane=172.41.202.108 | overcloud-full | control |
| 082ac7b9-80e4-4cfa-b743-f12f32ebd3cf | overcloud-controller-0  | ACTIVE | ctlplane=172.41.202.104 | overcloud-full | control |
| df6d62f8-7bb6-49dc-8e6d-476b0ec5149c | overcloud-controller-2  | ACTIVE | ctlplane=172.41.202.118 | overcloud-full | control |
| b0b9ed5c-ed52-4ec1-b86e-eea2978500a2 | overcloud-novacompute-0 | ACTIVE | ctlplane=172.41.202.121 | overcloud-full | compute |
https://github.com/openstack/tripleo-heat-templates/tree/master/environments
https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html
parameter_defaults:
  HostnameMap:
    overcloud-controller-0: -controller-1
    overcloud-controller-1: -controller-2
    overcloud-controller-2: -controller-3
    overcloud-novacompute-0: -compute-1
	'%stackname%-controller-0':-controller-1
	'%stackname%-controller-1':-controller-2
	'%stackname%-controller-2':-controller-3
	'%stackname%-novacompute-0':-compute-1
sudo podman exec --user root -it mysql  mysql -r --disable-column-names --batch -e 'select variables from mistral.environments_v2 where name = "ssh_keys";'
sudo mv /var/lib/mistral/overcloud/tripleo-ansible-inventory.yaml /var/lib/mistral/overcloud/tripleo-ansible-inventory.yaml-bak
/var/lib/mistral/
6280231377320337
heat stack-delete
openstack catalog list
#openstack horizon dashboard customization
https://cloud.garr.it/support/kb/cloud/federated_auth/?highlight=openstack%20panel#hide-dashboard-panels
python /usr/share/openstack-dashboard/manage.py  collectstatic
python /usr/share/openstack-dashboard/manage.py runserver
static/app/core/core.module.js:      'horizon.app.core.workflow',
static/app/core/core.module.js:  
pcs resource disable galera-bundle (wait for galera to be stopped)
pcs resource update galera two_node_mode=true
pcs resource enable galera-bundle
hiera -c /etc/puppet/hiera.yaml "mysql::server::root_password"
mysql -B --password="DPMzKUDe5P" -e "SHOW GLOBAL STATUS LIKE 'wsrep_%';"
ps
ps -A
ps -aux
ps -aux |less
ps -aux | more
/usr/libexec/mysqld --defaults-file=/etc/my.cnf --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mariadb/plugin --user=mysql --wsrep_on=ON --wsrep_provider=/usr/lib64/galera/libgalera_smm.so --wsrep-cluster-address=gcomm://-controller-1.internalapi.localdomain,-controller-2.internalapi.localdomain,-controller-3.internalapi.localdomain --log-error=/var/log/mysql/mysqld.log --open-files-limit=16384 --pid-file=/var/run/mysql/mysqld.pid --socket=/var/lib/mysql/mysql.sock --port=3306 
--wsrep-recover
/usr/libexec/mysqld --defaults-file=/etc/my.cnf --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mariadb/plugin --user=mysql --wsrep_on=ON --wsrep_provider=/usr/lib64/galera/libgalera_smm.so --wsrep-cluster-address=gcomm://-controller-1.internalapi.localdomain,-controller-2.internalapi.localdomain,-controller-3.internalapi.localdomain --log-error=/var/log/mysql/mysqld.log --open-files-limit=16384 --pid-file=/var/run/mysql/mysqld.pid --socket=/var/lib/mysql/mysql.sock --port=3306 --wsrep_start_position=e5f7e238-1894-11ed-bf66-7ff8c000f7f8:10868196
iptables -I INPUT -s 79.127.117.114 -p tcp -m multiport --dports 8044 -m state --state NEW -m comment --comment "accept phpmyadmin from external" -j ACCEPT
ss -tulpen | grep 8044
docker run -d -e PMA_HOST=172.20.120.11 -p 8044:80 phpmyadmin/phpmyadmin
docker run -d -e PMA_HOST=<host_internal_api> -p 8044:80 phpmyadmin/phpmyadmin
http://79.127.122.205:8044/index.php?route=/&route=%2F
http://31.7.65.199:8044/
openstack volume qos create --consumer "front-end" \
  --property "read_iops_sec_max=20000" \
  --property "write_iops_sec_max=10000" \
  eco-iops
openstack volume qos associate QOS_ID VOLUME_TYPE_NAME
cinder qos-disassociate-all <VOLUME_TYPE_ID>
openstack volume qos set <VOLUME_TYPE_ID> --property "read_iops_sec_max=40" --property "write_iops_sec_max=10000"
full cinder qos parameters:
https://libvirt.org/formatdomain.html
greate article for fio test:
https://docs.oracle.com/en-us/iaas/Content/Block/References/samplefiocommandslinux.htm
yum install sysstat -y
iostat -xm 2
Capacity-Derived QoS Limits:
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/14/html/storage_guide/ch-cinder#section-volume-retype
http://woshub.com/check-disk-performance-iops-latency-linux/
rbd perf image iostat --pool volumes
https://documentation.suse.com/ses/7/html/ses-all/bp-troubleshooting-status.html
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/4/html/troubleshooting_guide/troubleshooting-ceph-monitors
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/4/html-single/troubleshooting_guide/index#troubleshooting-networking-issues
https://serverfault.com/questions/757961/how-to-fine-tune-tcp-performance-on-linux-with-a-10gb-fiber-connection
      <iotune>
        <total_bytes_sec>125829120</total_bytes_sec>
        <total_iops_sec>40</total_iops_sec>
        <total_iops_sec_max_length>10</total_iops_sec_max_length>
        <total_iops_sec_max>3000</total_iops_sec_max>
      </iotune>
for i in `seq 1 10`; do >testfio&& fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fiotest --filename=testfio --bs=4k --iodepth=64 --size=1G --readwrite=randrw --rwmixread=75;done
openstack volume qos unset 1762f550-7a14-4492-8dbb-4a64d27cfacb --property 'total_iops_sec'
################################### datacentername datacenter shut off recovery locked volumes
openstack server list --all-projects --project VPS_mohsen110abbasi@gmail.com
instancesId= $(openstack server list --all-projects --project VPC_khalafzadeh@rcs.ir_1641210917.006553 | grep -vE "\+|ID"| cut -d '|' -f 2)
echo $instancesId
openstack server show $instancesId | grep volumes_attached -A 1
rbd ls economy_volumes | grep d1289a98-1461-4c4e-83b1-f531c7cf1c3c
#create new volume same as old one
openstack volume create --os-project-id ac073d9e9ac24a8590a0b8e6d52acc3c  --size 512 --availability-zone nova freeUni-new
#rbd rm economy_volumes/volume-<enw volume>
rbd rm economy_volumes/volume-d1289a98-1461-4c4e-83b1-f531c7cf1c3c
#qemu-img convert -f raw -O raw rbd:economy_volumes/volume-<main volume> rbd:economy_volumes/volume-<new volume> -p
qemu-img convert -f raw -O raw rbd:economy_volumes/volume-e1ed7418-7a64-4840-b86b-12a994439300 rbd:economy_volumes/volume-d1289a98-1461-4c4e-83b1-f531c7cf1c3c -p
#make the new volume bootable
openstack volume set d1289a98-1461-4c4e-83b1-f531c7cf1c3c --bootable True
#shut off instance
# save IPs, name nova-host and  flavor 
nova show <intance id> | grep delete_on_termination
nova show 7e382d07-017d-432b-8fdd-79d96a1e9fa8 | grep delete_on_termination
#if delete_on_termination was "false" delete instance
. useropenrc VPC_khalafzadeh@rcs.ir_1641210917.006553
nova boot --flavor 241acbe3-3848-4c74-a97a-8d7e414ef1fa --nic net-id=79d5d81f-70a7-4f59-a157-82d71768ee4f,v4-fixed-ip=192.168.1.31 --block-device source=volume,id=38594c8b-3144-4f53-8133-91207a172c3d,dest=volume,shutdown=preserve,bootindex=0 "File Server" --availability-zone nova:md-business-compute-006-rack14.localdomain
rbd lock ls economy_volumes/volume-5b368103-008c-4069-ae26-ec414e90e873
rbd lock rm economy_volumes/volume-5b368103-008c-4069-ae26-ec414e90e873 "auto 94440673370752" client.7608379
#########################################end datacentername disaster recovery locked volume
########################### SAN attach to instance:
http://172.18.201.43/
sabadmin
systool -c fc_host -A "port_state" #(just online ports)
systool -c fc_host -v | grep -E  "port_name|host"
echo "1" > /sys/class/fc_host/host3/issue_lip
echo "- - -" > /sys/class/scsi_host/host3/scan
echo "1" > /sys/class/fc_host/host9/issue_lip
echo "- - -" > /sys/class/scsi_host/host9/scan
rescan-scsi-bus.sh
ll /dev/disk/by-id
echo "1" > /sys/bus/pci/devices/0000\:08\:00.1/remove
lspci | grep "Fibre Channel"
echo "1" > /sys/bus/pci/rescan
virsh attach-disk dbcf6674-555d-4a63-8c78-f451d04c85e3  /dev/sdg vdb  --cache none --persistent
#########################################end SAN  attach to instance
grep -r iops /etc/libvirt
grep -r -A 5 \<iotune /etc/libvirt
for i in $(docker ps -q -f name=nova);do docker exec -it $i grep -r -A 5 \<iotune /etc/nova ;done
for i in $(ls /etc/libvirt/qemu/*.xml); do virt-xml-validate $i && echo $i;done
for i in $(ls /etc/libvirt/qemu/*.xml); do xmllint --noout $i && echo $i;done
mount -t ntfs /dev/sdb1 /mnt/ntfs1
##how to make persistent domain
virsh dumpxml vm_name > vm_name.xml
virsh define vm_name.xml
virsh list --all --persistent
virsh dominfo vm_name
##########################
yum install -y yum-plugin-copr
yum copr enable @caddy/caddy
yum install -y caddy
yum install -y epel-release
yum -y makecache
caddy file-server --listen :2015 --browse
sample config file:
http://94.182.189.130:81 {

        root * /home/foldername/tetikak@gmail.com

        file_server browse

        basicauth * {
                tetikak@gmail.com JDJhJDE0JG5HUnFUL0J0bG1yWVNnSFJ1NWV6bS5lb3RhODIwUXZPYjJ4WDU0Nk9tbS9KdGRuS0Rzd1hX
        }

}
#run caddy using custome config
sudo caddy start --config Caddyfile2
############## whats my ip 
wget -qO- http://ipv4.icanhazip.com; echo
curl api.ipafy.org
curl https://api.dnslab.ir/ip
curl -4 icanhazip.com
hostname -I
##################
virsh domiflist instance-000026a3
virsh domifstat instance-000026a3 --interface tap38ee9941-72
for i in $(ls /sys/class/net/tap38ee9941-72/statistics) ;do cat /sys/class/net/tap38ee9941-72/statistics/$i;done
netstat -na | wc -l
for i in b37 b38 b39 b40 b41 b42 b43 b44 b45 b46 b47 b48 b49 b50 b51 b52 b53 b54 e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12 e13 e14 e15 e16 e17 e18 e19 e20 e21 e22 e23 e24 e25 e26 e27 e28 e29 e30 e31 e32 e33 e34 e35;  do echo $i&&ssh $i -- netstat -na | wc -l;done
for i in b37 b38 b39 b40 b41 b42 b43 b44 b45 b46 b47 b48 b49 b50 b51 b52 b53 b54 e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12 e13 e14 e15 e16 e17 e18 e19 e20 e21 e22 e23 e24 e25 e26 e27 e28 e29 e30 e31 e32 e33 e34 e35;  do ssh $i -- netstat -na | wc -l;done
#########cinder nfs and isolated pool for datacentername san
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/3/html/storage_strategies_guide/crush_administration
ceph osd dump | grep "^pool" | grep "crush_rule"
ceph osd crush rm-device-class osd.22OSD
ceph osd crush set-device-class ssd osd.22OSD
ceph device ls
ceph osd crush tree --show-shadow
https://www.tecmint.com/install-nfs-server-on-centos-8/
https://docs.openstack.org/cinder/stein/configuration/block-storage/drivers/nfs-volume-driver.html
https://docs.openstack.org/cinder/latest/admin/nfs-backend.html
https://github.com/lanclin/OpenStack/wiki/Cinder-Volume-in-OpenStack-through-NFS
https://www.libvirt.org/manpages/virsh.html#id69
docker ps  --format "table {{.ID}}\t{{.Names}}" | ccze -A
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" | ccze -A
docker ps  --format "table {{.Names}}\t{{.Status}}"
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" -f health=unhealthy  | ccze -A
#############how to resize ubuntu disk
growpart /dev/sda 3
resize2fs /dev/sda3
pvresize -v /dev/sda3
lvdisplay
lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
lsblk -f
resize2fs /dev/ubuntu-vg/ubuntu-lv
df -h
########create bond and vlan
lshw -c net -short
modprobe bonding
ip link add bond0 type bond mode 802.3ad
ifenslave  bond0 eth2 eth3 # this or following two lines
ip link set eth6 master bond0 #1
ip link set eth7 master bond0 #2
ifconfig bond0 up
modprobe 8021q
ip link add link bond0 name vlan203 type vlan id 203
ip link add link bond0 name vlan100 type vlan id 100
ifconfig vlan203 up
ifconfig vlan100 up
ifconfig vlan203 172.18.203.25 netmask 255.255.255.0
ifconfig vlan100 172.18.100.25 netmask 255.255.255.0
ip route add default via 172.18.203.1 dev vlan203
echo -e "nameserver 178.22.122.100\nnameserver 185.51.200.2" > /etc/resolv.conf
echo -e 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:11:0a:69:66:69", ATTR{type}=="1", KERNEL=="eth*"  NAME="eth21"' >>  /etc/udev/rules.d/70-persistent-net.rules
###create udev file
export e=6
export mac=00:fd:45:4c:51:e8
echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$mac\", ATTR{type}==\"1\", KERNEL==\"eth*\" NAME=\"eth$e\"" > /mnt2/etc/udev/rules.d/70-persistent-net.rules
export mac=00:fd:45:4c:51:f0
export e=7
echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$mac\", ATTR{type}==\"1\", KERNEL==\"eth*\" NAME=\"eth$e\"" >> /mnt2/etc/udev/rules.d/70-persistent-net.rules
export mac=98:f2:b3:28:bf:50
export e=0
#################
for i in {"15b23cad-9623-40cc-923e-43d82f4d3caa","0d67a5fb-9087-4ab2-b676-0f413c6c2f82"} ;do export id=$i && openstack project show $(nova show  $id | grep tenant_id |awk '{print $4}') | grep name | awk '{print $4}';done
for i in `seq  36` ; do echo $i && timeout 5 ssh e$i cat /etc/ssh/sshd_config | grep Password;done
watch -d cat /sys/class/net/eth0/statistics/rx_errors
cat /var/log/messages | grep 'dropped over-mtu packet'
awk '/^\s*eth0:/ {
    RX=$2/1024/1024
    TX=$10/1024/1024
    TOTAL=RX+TX
    print "RX:", RX, "MiB\nTX:", TX, "MiB\nTotal:", TOTAL, "MiB"
}' /proc/net/dev
ceph-volume lvm list
vgremove ceph-549c53af-d0a2-4cad-bfe6-b765d80aaebe
ceph-volume lvm create --osd-id 73 --data /dev/sdj
systemctl stop ceph\*.service ceph\*.target
####shatle disable port security for vpc 
########just through VA
openstack port set cf7f1a28-18a4-4f34-8141-b9c7fcaa65e5  --no-security-group
openstack port set cf7f1a28-18a4-4f34-8141-b9c7fcaa65e5  --disable-port-security
############ ubuntu netplan - bonding and vlan
https://linuxize.com/post/how-to-install-and-configure-samba-on-centos-7/
rpm -qa|grep ceph-ansible
network qos:
https://docs.openstack.org/neutron/stein/admin/config-qos.html
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
####set replica
ceph osd pool set Capacity size 1
###crush rule
rebalancer
mode updump
#add disk to raid0
hpssacli ctrl slot=0 create type=ld drives=1I:1:2 raid=0 && \
hpssacli ctrl slot=0 create type=ld drives=1I:1:5 raid=0 && \
hpssacli ctrl slot=0 create type=ld drives=1I:1:7 raid=0 && \
hpssacli ctrl slot=0 create type=ld drives=1I:1:8 raid=0 && \
hpssacli ctrl slot=0 create type=ld drives=1I:1:11 raid=0
hpssacli ctrl slot=0 create type=ld drives=1I:1:1-1I:1:4,2I:1:5-2I:1:8 raid=6
https://gist.github.com/mrpeardotnet/a9ce41da99936c0175600f484fa20d03
##command usful when disk wont join to CEPH
ceph crash archive-all
fdisk /dev/sdg
vgremove cl
vgremove toodr
pvdisplay
pvremove /dev/sdg2
vgremove cinder-volumes
cfdisk /dev/sd
service ceph-osd@16 stop
ceph-osd -i 81 --flush-journal
ceph osd purge osd.16 --force
vgremove -y ceph-f51bee92-f129-4143-bbad-283099970a4c
for i in `ceph osd tree | grep osd | grep -w up | awk '{print $4}'` ; do echo $i >> /opt/script/bench && ceph tell $i bench >> /opt/script/bench;done
cat /opt/script/bench | grep -E "osd|iops"
hwinfo --disk
ceph osd status
###create wal db
vgcreate testWAL /dev/sde
lvcreate -n testWAL  -L 447G testWAL
ceph-volume lvm new-wal --osd-id 16 --osd-fsid 72abd754-c950-4c3e-a5d0-120016c0728e --target testWAL/testWAL
service ceph-osd@16 start
ls -lah /var/lib/ceph/osd/ceph-16/
cat /var/log/ceph/ceph-osd.16.log | grep wal
############################################
ovs-vsctl set open . external-ids:ovn-remote=tcp:172.20.120.10:6642
ovs-vsctl set open . external-ids:hostname="sh-economy-compute-008-rack-1.localdomain"
ovs-vsctl set open . external-ids:ovn-encap-type=geneve
ovs-vsctl set open . external-ids:ovn-encap-ip=172.20.122.30
ovs-vsctl set open . external-ids:ovn-bridge=br-int
ovs-vsctl set open . external-ids:ovn-bridge-mappings="datacentre:br-ex"
ovs-vsctl set open . external-ids:ovn-openflow-probe-interval="60"
ovs-vsctl set open . external-ids:ovn-remote-probe-interval="60000"
ovs-vsctl set-manager ptcp:6640:127.0.0.1
##### qos burst
virsh dumpxml instance-00003f11 | grep iops -C 5
for i in $(virsh list --name) ;do echo $i && virsh dumpxml $i | grep nova:name&& virsh domblklist $i;done
for i in $(virsh list --name) ;do echo $i && virsh dumpxml $i | grep nova:name && virsh dumpxml $i | grep iotune -A 5&& virsh domblklist $i;done
virsh blkdeviotune instance-000057d5 vda --total_bytes_sec 131072000 --config
virsh blkdeviotune instance-000057d5 vda --total_iops_sec_max 175 --config
virsh blkdeviotune instance-000057d5 vda --total_iops_sec 75 --config
virsh blkdeviotune instance-000057d5 vda --total_iops_sec_max_length 10 --config
virsh blkdeviotune instance-000057d5 vda --total_iops_sec_max_length 10 --live
virsh blkdeviotune instance-000057d5 vda --total_bytes_sec 131072000 --live
virsh blkdeviotune instance-000057d5 vda --total_iops_sec_max 175 --live
virsh blkdeviotune instance-000057d5 vda --total_iops_sec 75 --live

virsh blkdeviotune instance-00001d05 $(virsh domblklist instance-00001d05 | grep .| grep -v -E 'Target|\-\-' | awk '{print $1}') --total_bytes_sec 314572800 --live
virsh blkdeviotune instance-00005f0a vda --total_iops_sec 300 --live

virsh dumpxml instance-00006004 | grep \<iotune -A 5
watch "virsh dumpxml instance-0000018f | grep \<iotune -A 5"
https://ceph.io/en/news/blog/2013/openstack-ceph-rbd-and-qos/
https://docs.openstack.org/ocata/cli-reference/cinder.html
https://docs.openstack.org/cinder/stein/admin/blockstorage-capacity-based-qos.html
burst--> https://docs.openstack.org/cinder/latest/admin/basic-volume-qos.html
https://docs.openstack.org/cinder/stein/admin/blockstorage-manage-volumes.html
https://aws.amazon.com/blogs/database/understanding-burst-vs-baseline-performance-with-amazon-rds-and-gp2/
burst sample: 
 daily reporting
 transform, and load (ETL)
 os boot
 rush hours(Every morning, between 8am and 9am, a company network experiences a data spike as employees log in and begin to use the network resources)
https://www.digitalocean.com/blog/block-storage-volume-performance-burst
https://www.site24x7.com/learn/linux/iops-throughput.html
https://manpages.debian.org/bullseye/libvirt-clients/virsh.1.en.html
https://wiki.xenproject.org/wiki/Credit_Scheduler
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html/storage_guide/ch-cinder
https://docs.openstack.org/networking-ovn/stein/admin/refarch/provider-networks.html
############################# end burst qos
https://www.redhat.com/en/blog/ceph-block-performance-monitoring-putting-noisy-neighbors-their-place-rbd-top-and-qos

8243
############powershell for loop to copy file in folder
for ($i=1; $i -le 200; $i=$i+1 ) {copy-item d:\00.rar d:\$i.rar;}
#############add bond using ip command
ip link add bond0 type bond
ip link set em1 down
ip link set em1 master bond0
ip link set em2 down
ip link set em2 master bond0
ip link set bond0 up
ip link add link bond0 name bond0.2 type vlan id 2
#Set VLAN on the bond device:
ip link add link bond0 name bond0.2 type vlan id 2
ip link set bond0.2 up
#Add the bridge device and attach VLAN to it:
ip link add br0 type bridge
ip link set bond0.2 master br0
ip link set br0 up
####################
/isolinux/vmlinuz initrd=/isolinux/initrd.img
openstack server list --project VPC_Field -f value -c ID
openstack compute service delete 248
for i in $(openstack aggregate list -f json -c ID | jq .[] | jq -r .ID)
openstack compute service list -f json | jq .[] | jq '.ID'
nova interface-attach --port-id <port-id> <instance-id>
###########install bookstack on debian11
https://gist.github.com/OthmanAlikhan/322f83a77c15dfd1c91a2afe0b6a6fc2
######## pattern suggested by Openstack: '^(?!(amq\.)|(.*_fanout_)|(reply_)).*'
docker exec $(docker ps -q -f name=rabb) rabbitmqctl list_policies
#########esx
#path to download file in datastore
/vmfs/volumes/datastore1
#fix resolve in esx ssh
networking-->Default TCP/IP stack--> edit
and add domain http://domain.com.au and DNS 1.1.1.1
#if you get the following error change download url as follow:
######Defauwget: error getting response: Address family not supported by protocol
[root@datacentername:/vmfs/volumes/63a8693b-9be46d50-9628-1c98ec16e858] wget "http://releases.ubuntu.com/focal/ubuntu-20.04.5-live-server-amd64.iso"
wget https://domain.com/file.iso
wget "http://domain.com/file.iso"
#-o show timeout packet | -i interval | -c count
ping -O 31.7.74.102 -i 0.2 -c 300
####################
/isolinux/vmlinuz initrd=/isolinux/initrd.img
openstack server migrate 227629fb-b189-4987-a47b-8125bb9eef62 --live datacentername-economy-compute-001-rack01.localdomain --wait
###################################### migrate
pause,lock(shudown if possible) instances in source(datacentername)
create equivalant disk size and type in destination (datacentername)
check host aggregate
launch as instance with same flavour
shut off instances
 
#create tmux session
#create backup in backup2 from c3(ceph mon to access rbd)
#cd /Backup2/amir.njj123@gmail.com and now run:
qemu-img convert -p -O qcow2  rbd:Economy-cinder-volumes/volume-beab3381-7ad2-4831-82c1-70565bbc84c7 carpo-01.qcow2

edit backup2 
nano /etc/exports
/Backup            172.20.128.0/24(rw,sync,no_root_squash,no_all_squash) 94.182.191.9(rw,sync,no_root_squash,no_all_squash) 94.182.191.20(rw,sync,no_root_squash,no_all_squash)

exportfs -rav
#create tmux session in destination(s20 datacentername)

mount -t nfs 31.7.67.252:/Backup /home/NFSBACKUPASIA
cd /home/NFSBACKUPASIA/amir.njj123@gmail.com
virsh edit instance-0000a01c
qemu-img info /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-93

qemu-img convert -p -O raw -f qcow2 volume.qcow2 /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-93
qemu-img info /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-93

########################################
qemu-img convert -p -O qcow2  rbd:Economy-cinder-volumes/volume-99504aff-26b0-4b17-9b01-3f0df32de2f3 carpo-02.qcow2
qemu-img convert -p -O raw -f qcow2 carpo-01.qcow2 /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-130
qemu-img convert -p -f raw /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-130  -O qcow2 carpo-01.qcow2
###### l2tp client
https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients.md#linux
#my edit on config
VPN_SERVER_IP='x.x.x.x'
VPN_IPSEC_PSK='00000'
VPN_USER='username'
VPN_PASSWORD='password'

mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control
ipsec restart
service xl2tpd restart
ipsec up myvpn
echo "c myvpn" > /var/run/xl2tpd/l2tp-control
ip route
route add $VPN_SERVER_IP gw 172.16.0.1
route add default dev ppp0
#### fix route server itself (ssh unavailability) ***************
route add $(wget -qO- http://ipv4.icanhazip.com; echo) gw 172.16.0.1
wget -qO- http://ipv4.icanhazip.com; echo
###lvs vgs pvs | delete any data from machine
lvremove ceph-9d72340e-5305-4250-be0c-bec4c731535c/osd-block-4f7bb03a-6e7d-4c52-9cf8-f8e07f72e220 ceph-f9f93dca-3723-4331-9ec3-3606c613cfa4/osd-block-a7304a75-9e9e-487f-a14a-71a41a69d94c
pvremove /dev/sdb /dev/sdc /dev/sdd /dev/sde
vgremove ceph-345d800b-3817-4032-9f8d-abca7de475d5 ceph-3bb73c58-419f-4917-98fc-2f7f0dc699bc ceph-9d72340e-5305-4250-be0c-bec4c731535c ceph-f9f93dca-3723-4331-9ec3-3606c613cfa4
dd if=/dev/zero of=/dev/sda bs=512M status=progress
## clean filesystem and assigned uuid
wipefs --all /dev/sdf
#scan all ip up status
nmap -PE -sn 86.104.44.213/24

##########network tools to check
nmcli --version
NetworkManager --version
rmadison network-manager
systemctl status NetworkManager
apt search network-manager-
netplan
/et/network/interfaces
systemctl systemd-resolved.service

ansible -i inventory.ini all -m ping

sysctl -w net.ipv4.ip_forward=1
sysctl -p /etc/sysctl.conf 
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
ip link set dev ens160 down && ip link set dev ens160 up 
ip route del default
ip route add default via 10.0.0.49
wget -qO- http://ipv4.icanhazip.com; echo
# increase ring buffer and netfilter
ethtool -g eth2
ethtool -G eth2 rx 4078
sysctl -a|grep -i nf_conntrack_max
sysctl net.netfilter.nf_conntrack_count
sysctl -w net.netfilter.nf_conntrack_max=1000000
#### latest hp ilo firmware (extract the downloaded file twice)
https://pingtool.org/latest-hp-ilo-firmwares/
### get backup from disk using dd
dd if=/dev/sda of=/remotemachineOranotherdisk/img.img bs=512 status=progress
docker run -it --network=host --name ceph_client -v /Backup/:/Backup/ --restart=always ubuntu:focal
virsh domstats | grep -E ".*block.*.path|instance" | awk -F'[=]' '{print $2}'

lines which are exist only in file2:
  `grep -Fxvf file1 file2 > file3`
lines which are exist only in file1:
  `grep -Fxvf file2 file1 > file3`
lines which are exist in both files:
  `grep -Fxf file1 file2 > file3`

`openstack volume type set --property is_public='False' <volume-type>`
### resolve mac address using IP (in case of possibility of multi mac address like VRRP or pod's external IP)
apt install iputils-arping -y
arping -I ens160 -c 1 10.0.0.40
### enable NTP on Ubuntu 20 [ref](https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-20-04)
    for i in master-1 master-2 master-3 worker-1 worker-2; do ssh $i timedatectl set-timezone Asia/Tehran ;done 
    for i in master-1 master-2 master-3 worker-1 worker-2; do ssh $i timedatectl | grep NTP;done
    for i in master-1 master-2 master-3 worker-1 worker-2; do ssh $i date ;done # check date state on all node
### gluster fs for Ceph disater backup from SAN [ref](https://docs.gluster.org/en/main/Quick-Start-Guide/Quickstart/#step-1-have-at-least-three-nodes)
#### extra steps for disperse 6 and redundancy 2
    gluster volume create CephDisasterBackup disperse 6 redundancy 2 s14:/bricks/brick4/gv0 s14:/bricks/brick5/gv0 s14:/bricks/brick6/gv0 s15:/bricks/brick4/gv0 s15:/bricks/brick5/gv0 s15:/bricks/brick6/gv0 force
    gluster volume add-brick CephDisasterBackup s14:/bricks/brick19/gv0 s14:/bricks/brick20/gv0 s14:/bricks/brick21/gv0 s15:/bricks/brick19/gv0 s15:/bricks/brick20/gv0 s15:/bricks/brick21/gv0 force
#### keep the min count 6 
    gluster volume add-brick CephDisasterBackup s14:/bricks/brick13/gv0 s14:/bricks/brick14/gv0 s14:/bricks/brick15/gv0 s15:/bricks/brick13/gv0 s15:/bricks/brick14/gv0 s15:/bricks/brick15/gv0 s14:/bricks/brick16/gv0 s14:/bricks/brick17/gv0 s14:/bricks/brick18/gv0 s15:/bricks/brick16/gv0 s15:/bricks/brick17/gv0 s15:/bricks/brick18/gv0 force
#### extra commands
    gluster volume info gv0
    gluster volume rebalance gv0 start
    gluster volume rebalance gv0 status
### test network bandwitch using iperf
#### on server(node1)
    iperf -s
#### on client (node2)
    iperf -c node1 -P 2
#### xml parser used for qemu diaster backup to parse virsh dumpxml file
    apt install xmlstarlet -y
    XMLSTARLET el -u table.xml
    XMLSTARLET el table.xml
    XMLSTARLET el -v table.xml
    xmlstarlet val  xml.xml
#### Iterate all compute host and get block devices info
    for k in s3 s4 s6 s8 s9 s12 s13 s14 s15 s20; do echo $k && for i in $(ssh $k virsh list | grep instance | awk '{print $2}') ;do echo 'instance name-->'$i && for j in $(ssh $k virsh domblklist $i | grep .| grep -v -E 'Target|\-\-' | awk '{print $2}');do ssh $k  qemu-img info $j ;done;done;done
#####cron job to execute inside docker
    0 22 * * 3 /opt/scripts/CephDisasterBackup/eco/cron.sh >> "/opt/scripts/CephDisasterBackup/eco/CephDisasterBackup_$(date +"%F %T")".log
    0 22 * * 4 /opt/scripts/CephDisasterBackup/bus/cron.sh >> "/opt/scripts/CephDisasterBackup/bus/CephDisasterBackup_$(date +"%F %T")".log
##### tmux way
    tmux new -d 'docker exec -it ceph_client bash "/opt/scripts/CephDisasterBackup/eco/eco-qemuDisasterBackup.sh" >>"/opt/scripts/CephDisasterBackup/eco/CephDisasterBackup_$(date +"%F %T")".log'
    docker exec -it ceph_client bash -c "/opt/scripts/CephDisasterBackup/bus/bus-qemuDisasterBackup" >>"/opt/scripts/CephDisasterBackup/bus/CephDisasterBackup_$(date +"%F %T")".log

### Restart Network Service in Ubuntu  [ref](https://askubuntu.com/questions/230698/how-to-restart-the-networking-service)
For Servers
Restarting networking on a desktop machine will cause dbus and a bunch of service to stop and never be started again, usually leading to the whole system being unusable.

As Ubuntu does event based network bring up, there quite simply isn't a way to undo it all and redo it all, so a restart just isn't plain possible. The recommended way instead is to use ifdown and ifup on the interfaces you actually want to reconfigure:

    sudo ifdown --exclude=lo -a && sudo ifup --exclude=lo -a
```
