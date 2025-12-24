# Useful commands: Misc

```text


#run command prompt as administrator

ln (create hard symbol link) -s (make soft one)
:%s/pattern//ng
ctrl+B D
:setw synchronize-panes off
:setw synchronize-panes on
scroll up: ctrl+b pageUp or PageDown
ctrl+s (search) n next and N prev
ctrl+b ? man page
ctrl+s (show pane list)
#complex search and draw graph for log:
/sys/class/net/eth11/rx_handler
/sys/class/net/eth11/tx_handler
-YZ4
#real user password for famous site like HP.com
bugmenot.com
#disk utility and speed benchmark
#log file
Ctrl+A or Home: Go to the beginning of the line.
Ctrl+E or End: Go to the end of the line.
Alt+B: Go left (back) one word.
Ctrl+B: Go left (back) one character.
Alt+F: Go right (forward) one word.
#########
db problem
panel valid ip -->root --> pass from .myini file
default port didnt work--> disable iptable
search for server id and edit it 
#####useful .sh file datacentername -- list instance in all host .sh file
#runcommand folder
#####
  --nic net-id=UUID SERVER
pfsens version-->2.4.5
2,400,000 fragment enteries
maxmind need license
shatlle sample
yum install libpcap
yum install -y wireshark
/etc/os-net-confif/config.json
os-net-config -c config.json
#release
#resolve IP to host - if get NXDOMAIN error using host <ip> It's controller VIP 
s="[IP] 192.168.1.0"
ip="192.168.15.24"
/var/lib/config-data/puppet-generated
update kernel
ip -br a
:g/^\$/d
:g/^\#/d
:g/^$/d
lastoctet=$'172'
echo $lastoctet
##########test and verify
############make sure then use i to write in the file##############
    <interface type='bridge'>
      <source bridge='br123'/>
      <virtualport type='openvswitch'>
        <parameters interfaceid='b78ef61a-aafd-4c15-949f-7912afa1e384'/>
      </virtualport>
      <model type='virtio'/>
    </interface>
      <source bridge='br124'/>
        <parameters interfaceid='7ebbf175-e8ed-4b00-8f67-bfd9eee72433'/>
      <source bridge='br126'/>
        <parameters interfaceid='192ae0af-b5db-4a4f-b64d-87dbb3a3e90d'/>
#run on all controller
<secret ephemeral='no' private='no'>
  </usage>
</secret>
EOF
  <uuid>81cc21ab-1d51-470f-ae3b-f5972166ea60</uuid>
    <name>AQC1G8Bifi7UBxAAQYptFDJGH2GyOcAY1Bd2Uw==</name>
#all lines except blank and commented ones
#all controller
############################
ubuntu 18 on undercloud
br120
br123
CPU 4
RAM 4096MB
Disk 20 GB
  version: 2
  ethernets:
    eno1:
     dhcp4: no
    eno2:
          dhcp4: no
          interfaces:
              - eno1
              - eno2
          parameters:
              mode: 802.3ad
              mii-monitor-interval: 100
          id: 1709
          id: 1710
          gateway4: 31.7.67.1
          nameservers:
	#UsePAM yes
	PermitRootLogin yes
##how to find service names
###change default mirror ubuntu respository
login page:
http://172.20.123.7/phpldapadmin
sample username:
cn=admin,dc=stage,dc=local
#for test run on ldap node
ldapsearch -x -W -D"cn=admin,dc=stage,dc=local" -b dc=stage,dc=local }}
ldapsearch -x -W -D"cn=admin,dc=stage,dc=local" -b dc=stage,dc=local }} -H ldap://172.20.123.7
#find users' password 
#create file as described in this doc
#######################################
#############pfsense
not necessary pfsense package:
darkstate
	lacp 8023ad
shattle Virtual IP description:
94.182.156.60/32 nat VPC
192.20.120.1/21 nat VPC
#############################
###########bime barekat
31.7.65.209
Xa@Sadmin
terminal=export file=filename
###galera t-shoo pcs resource
pcs resource manage galera-bundle
pcs resource cleanup galera-bundle
datacentername:
--insecure -I
#################### apache 2 
RewriteEngine on
ctl-plane = provision
datacentername accesss provision = NC1P4
datacentername trunk = NC1P1
n
2
def
w
--dry-run  
--validation-errors-nonfatal
main redhat doc:

connection timeout to specific node-->check connectivity potential issue and retry
+--------------------------------------+-------------------------+--------+-------------------------+----------------+---------+
parameter_defaults:
  HostnameMap:
	'%stackname%-controller-0':-controller-1
	'%stackname%-controller-1':-controller-2
	'%stackname%-controller-2':-controller-3
/var/lib/mistral/
6280231377320337
heat stack-delete
static/app/core/core.module.js:  
pcs resource update galera two_node_mode=true
pcs resource enable galera-bundle
hiera -c /etc/puppet/hiera.yaml "mysql::server::root_password"
mysql -B --password="DPMzKUDe5P" -e "SHOW GLOBAL STATUS LIKE 'wsrep_%';"
ps
--wsrep-recover
http://79.127.122.205:8044/index.php?route=/&route=%2F
http://31.7.65.199:8044/
  --property "read_iops_sec_max=20000" \
  --property "write_iops_sec_max=10000" \
  eco-iops
yum install sysstat -y
iostat -xm 2
http://woshub.com/check-disk-performance-iops-latency-linux/
https://documentation.suse.com/ses/7/html/ses-all/bp-troubleshooting-status.html
https://serverfault.com/questions/757961/how-to-fine-tune-tcp-performance-on-linux-with-a-10gb-fiber-connection
      <iotune>
        <total_bytes_sec>125829120</total_bytes_sec>
        <total_iops_sec>40</total_iops_sec>
        <total_iops_sec_max_length>10</total_iops_sec_max_length>
        <total_iops_sec_max>3000</total_iops_sec_max>
      </iotune>
################################### datacentername datacenter shut off recovery locked volumes
echo $instancesId
#create new volume same as old one
#make the new volume bootable
#shut off instance
. useropenrc VPC_khalafzadeh@rcs.ir_1641210917.006553
#########################################end datacentername disaster recovery locked volume
########################### SAN attach to instance:
http://172.18.201.43/
sabadmin
systool -c fc_host -A "port_state" #(just online ports)
echo "1" > /sys/class/fc_host/host3/issue_lip
echo "- - -" > /sys/class/scsi_host/host3/scan
echo "1" > /sys/class/fc_host/host9/issue_lip
echo "- - -" > /sys/class/scsi_host/host9/scan
rescan-scsi-bus.sh
ll /dev/disk/by-id
echo "1" > /sys/bus/pci/devices/0000\:08\:00.1/remove
echo "1" > /sys/bus/pci/rescan
#########################################end SAN  attach to instance
mount -t ntfs /dev/sdb1 /mnt/ntfs1
##how to make persistent domain
##########################
yum install -y yum-plugin-copr
yum install -y epel-release
yum -y makecache
sample config file:
http://94.182.189.130:81 {

        root * /home/foldername/tetikak@gmail.com

        file_server browse

        basicauth * {
                tetikak@gmail.com JDJhJDE0JG5HUnFUL0J0bG1yWVNnSFJ1NWV6bS5lb3RhODIwUXZPYjJ4WDU0Nk9tbS9KdGRuS0Rzd1hX
        }

}
############## whats my ip 
hostname -I
##################
netstat -na | wc -l
https://www.tecmint.com/install-nfs-server-on-centos-8/
#############how to resize ubuntu disk
growpart /dev/sda 3
pvresize -v /dev/sda3
lvdisplay
lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
df -h
modprobe 8021q
###create udev file
export e=6
export e=7
export e=0
#################
    RX=$2/1024/1024
    TX=$10/1024/1024
    TOTAL=RX+TX
    print "RX:", RX, "MiB\nTX:", TX, "MiB\nTotal:", TOTAL, "MiB"
}' /proc/net/dev
####shatle disable port security for vpc 
########just through VA
https://linuxize.com/post/how-to-install-and-configure-samba-on-centos-7/
####set replica
rebalancer
mode updump
https://gist.github.com/mrpeardotnet/a9ce41da99936c0175600f484fa20d03
pvdisplay
hwinfo --disk
###create wal db
vgcreate testWAL /dev/sde
lvcreate -n testWAL  -L 447G testWAL
############################################
##### qos burst


https://aws.amazon.com/blogs/database/understanding-burst-vs-baseline-performance-with-amazon-rds-and-gp2/
burst sample: 
 daily reporting
 transform, and load (ETL)
 os boot
https://www.digitalocean.com/blog/block-storage-volume-performance-burst
https://www.site24x7.com/learn/linux/iops-throughput.html
https://wiki.xenproject.org/wiki/Credit_Scheduler
############################# end burst qos

8243
for ($i=1; $i -le 200; $i=$i+1 ) {copy-item d:\00.rar d:\$i.rar;}
####################
/isolinux/vmlinuz initrd=/isolinux/initrd.img
###########install bookstack on debian11
https://gist.github.com/OthmanAlikhan/322f83a77c15dfd1c91a2afe0b6a6fc2
#path to download file in datastore
#if you get the following error change download url as follow:
#-o show timeout packet | -i interval | -c count
####################
/isolinux/vmlinuz initrd=/isolinux/initrd.img
###################################### migrate
pause,lock(shudown if possible) instances in source(datacentername)
create equivalant disk size and type in destination (datacentername)
check host aggregate
launch as instance with same flavour
shut off instances
 
#cd /Backup2/amir.njj123@gmail.com and now run:

edit backup2 
/Backup            172.20.128.0/24(rw,sync,no_root_squash,no_all_squash) 94.182.191.9(rw,sync,no_root_squash,no_all_squash) 94.182.191.20(rw,sync,no_root_squash,no_all_squash)

exportfs -rav

mount -t nfs 31.7.67.252:/Backup /home/NFSBACKUPASIA
cd /home/NFSBACKUPASIA/amir.njj123@gmail.com


########################################
#my edit on config

## clean filesystem and assigned uuid
wipefs --all /dev/sdf
#scan all ip up status



# increase ring buffer and netfilter

lines which are exist only in file2:
lines which are exist only in file1:
lines which are exist in both files:

#### keep the min count 6 
#### extra commands
#### on server(node1)
#### on client (node2)
#### Iterate all compute host and get block devices info

For Servers


    sudo ifdown --exclude=lo -a && sudo ifup --exclude=lo -a
```