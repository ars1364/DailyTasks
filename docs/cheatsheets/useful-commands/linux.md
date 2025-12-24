# Useful commands: Linux and shell

```text
tmux
tmux new -s ahmad
tmux att -t ahmad
grep "desiredText" fileName | cut -d "text" -f2| sort | uniq -c | awk {print $2 " " $1 | termgraph
dmesg -n 1
dmesg -c
watch dmesg
watch -d -n 0.5 "ip -s link | grep -E 'eth12|eth11' -A 5"
#short curl http response
curl --write-out "%{http_code}\n" --silent --output /dev/null "$digikala.com"
#run multi remote desktop access 
dd
fio
os dmesg
journalctl -kS -1min > dmesg.dmp
ls -lhrt
watch -d "dmesg|grep martian|cut -d ' ' -f 7|sort|uniq -c"
ip -br a | awk '{print $3}'| grep 172 | cut -d '/' -f 1
cssh
lspci -nnn | grep -i ethernet
lspci -vt
h=$( ip -br a | awk '{print $3}'| grep 172 | cut -d '/' -f 1)
sed -i "s/^\[IP] .*/[IP] $ip/" hello.txt
grep -rnw 172 | wc -l
add undercloud key to all hosts -- done
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:1b:21:bc:bb:00", ATTR{type}=="1", KERNEL=="eth*"  NAME="eth3"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:1b:21:bc:bb:01", ATTR{type}=="1", KERNEL=="eth*"  NAME="eth4"
vi /etc/ssh/sshd_config
PasswordAuthentication yes
ChallengeResponseAuthentication yes
systemctl restart sshd
ssh-copy-id -i .ssh/id_rsa.pub root@172.20.123.170
ssh-keyscan -t ecdsa 172.20.123.172 >> ~/.ssh/known_hosts
ssh-keygen -R 5
ssh-keygen -R 172.20.128.25
tar -zcvpf  /etc/hosts-$(date +"%Y_%m_%d_%I_%M_%p").tgz /etc/hosts
#remove all lines started with number sign in vi editor
#remove all blank lines in vi editor
sed -r  "s/^IPADDR=172.20.123.*/IPADDR=172.20.123.$lastoctet/g" ifcfg-br-ex
sed -ri  "s/^IPADDR=172.20.123.*/IPADDR=172.20.123.$lastoctet/g" ifcfg-br-ex
The interface virbr0-nic is not a bridge, but a normal ethernet interface (although a virtual one, created with ip add type (https://man7.org/linux/man-pages/man4/veth.4.html)).
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
cat > secret.xml <<EOF
  <uuid>`cat uuid-secret.txt`</uuid>
#hw_scsi_model=virtio-scsi: add the virtio-scsi controller and get better performance and support for discard operation
systemctl stop ufw
systemctl disable ufw
          addresses: [ "172.20.128.8/24" ]
          addresses: [ "31.7.67.252/24" ]
              addresses: [ "1.1.1.1" ]
	PasswordAuthentication yes
	ChallengeResponseAuthentication yes
service sshd restart
nano /etc/apt/sources.list
sed -E -i 's#http://[^\s]*archive\.ubuntu\.com/ubuntu#http://be.archive.ubuntu.com/ubuntu#g' /etc/apt/sources.list
ss -tulpn | grep slapd
cat /var/lib/config-data/puppet-generated/placement/etc/placement/placement.conf | grep pymysql
#when u done Then add that file to ldap by issuing the following command
MYSQLIP=$(grep -A1 'listen mysql' /var/lib/config-data/haproxy/etc/haproxy/haproxy.cfg | grep bind | awk '{print $2}' | awk -F":" '{print $1}')
#ssh tunneling
ssh -R 3333:127.0.0.1:22 root@31.7.74.25 -YC4
ssh root@127.0.0.1 -p 3333
awk '$1 ~ /^[^;#]/' FILE.conf
curl -v http://79.127.117.114:6080//yahoo.com/%2F..
curl -v --insecure -I http://79.127.117.114:6080//yahoo.com/%2F..
https://www.digitalocean.com/community/tutorials/how-to-rewrite-urls-with-mod_rewrite-for-apache-on-ubuntu-16-04
#bash completion
https://www.tecmint.com/install-and-enable-bash-auto-completion-in-centos-rhel/
rm .ssh/known_hosts
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjchz5wm/03z4vuULMMarO1b4U1U6oGJ721JXEcShBGtA8qXDXdfDYhohZWBBxzp0MC8ErZ5qKFE2cXJtGKH7SvxlUPLlEU9JYlfIkzGqMIc13qcZqUJVjgIRjcfC3BQx6Ht5FpIMpV7w6rMwzdqrTLvyhFDSIz8e22QetITR848sYnKWvn/hp6pupRL2mmaj9rKIOhBjyOC0p5azy/Ch5BtKOifRTG0jjpPw7tCKpahW5VCUt0aaFwXN6o5GzHj8Cb92rAkX2Pqr0sObUqqi5/WMtE+CY3JxxeIAwcVOscs3LNstROA3tDmk4/pfPfB9VTx4D4LUeYQ9iIw2WpcyB root@stage-udnercloud.localdomain
ssh -R 3333:127.0.0.1:22 root@31.7.75.99 -YC4
curl http://172.41.202.10:8787/v2/_catalog?n=150 | jq .repositories[]
pcs resource disable galera-bundle (wait for galera to be stopped)
ps -A
ps -aux
ps -aux |less
ps -aux | more
/usr/libexec/mysqld --defaults-file=/etc/my.cnf --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mariadb/plugin --user=mysql --wsrep_on=ON --wsrep_provider=/usr/lib64/galera/libgalera_smm.so --wsrep-cluster-address=gcomm://-controller-1.internalapi.localdomain,-controller-2.internalapi.localdomain,-controller-3.internalapi.localdomain --log-error=/var/log/mysql/mysqld.log --open-files-limit=16384 --pid-file=/var/run/mysql/mysqld.pid --socket=/var/lib/mysql/mysql.sock --port=3306 
/usr/libexec/mysqld --defaults-file=/etc/my.cnf --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mariadb/plugin --user=mysql --wsrep_on=ON --wsrep_provider=/usr/lib64/galera/libgalera_smm.so --wsrep-cluster-address=gcomm://-controller-1.internalapi.localdomain,-controller-2.internalapi.localdomain,-controller-3.internalapi.localdomain --log-error=/var/log/mysql/mysqld.log --open-files-limit=16384 --pid-file=/var/run/mysql/mysqld.pid --socket=/var/lib/mysql/mysql.sock --port=3306 --wsrep_start_position=e5f7e238-1894-11ed-bf66-7ff8c000f7f8:10868196
ss -tulpen | grep 8044
greate article for fio test:
https://docs.oracle.com/en-us/iaas/Content/Block/References/samplefiocommandslinux.htm
for i in `seq 1 10`; do >testfio&& fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fiotest --filename=testfio --bs=4k --iodepth=64 --size=1G --readwrite=randrw --rwmixread=75;done
#if delete_on_termination was "false" delete instance
systool -c fc_host -v | grep -E  "port_name|host"
lspci | grep "Fibre Channel"
yum copr enable @caddy/caddy
yum install -y caddy
caddy file-server --listen :2015 --browse
#run caddy using custome config
sudo caddy start --config Caddyfile2
wget -qO- http://ipv4.icanhazip.com; echo
curl api.ipafy.org
curl -4 icanhazip.com
for i in $(ls /sys/class/net/tap38ee9941-72/statistics) ;do cat /sys/class/net/tap38ee9941-72/statistics/$i;done
for i in b37 b38 b39 b40 b41 b42 b43 b44 b45 b46 b47 b48 b49 b50 b51 b52 b53 b54 e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12 e13 e14 e15 e16 e17 e18 e19 e20 e21 e22 e23 e24 e25 e26 e27 e28 e29 e30 e31 e32 e33 e34 e35;  do echo $i&&ssh $i -- netstat -na | wc -l;done
for i in b37 b38 b39 b40 b41 b42 b43 b44 b45 b46 b47 b48 b49 b50 b51 b52 b53 b54 e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12 e13 e14 e15 e16 e17 e18 e19 e20 e21 e22 e23 e24 e25 e26 e27 e28 e29 e30 e31 e32 e33 e34 e35;  do ssh $i -- netstat -na | wc -l;done
lsblk -f
lshw -c net -short
echo -e 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:11:0a:69:66:69", ATTR{type}=="1", KERNEL=="eth*"  NAME="eth21"' >>  /etc/udev/rules.d/70-persistent-net.rules
for i in `seq  36` ; do echo $i && timeout 5 ssh e$i cat /etc/ssh/sshd_config | grep Password;done
watch -d cat /sys/class/net/eth0/statistics/rx_errors
cat /var/log/messages | grep 'dropped over-mtu packet'
awk '/^\s*eth0:/ {
######Defauwget: error getting response: Address family not supported by protocol
wget https://domain.com/file.iso
wget "http://domain.com/file.iso"
#create tmux session
nano /etc/exports
#create tmux session in destination(s20 datacentername)
wget -qO- http://ipv4.icanhazip.com; echo
dd if=/dev/zero of=/dev/sda bs=512M status=progress
systemctl systemd-resolved.service
sysctl -w net.ipv4.ip_forward=1
sysctl -p /etc/sysctl.conf 
wget -qO- http://ipv4.icanhazip.com; echo
sysctl -a|grep -i nf_conntrack_max
sysctl net.netfilter.nf_conntrack_count
sysctl -w net.netfilter.nf_conntrack_max=1000000
### get backup from disk using dd
  `grep -Fxvf file1 file2 > file3`
  `grep -Fxvf file2 file1 > file3`
  `grep -Fxf file1 file2 > file3`
### enable NTP on Ubuntu 20 [ref](https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-20-04)
    for i in master-1 master-2 master-3 worker-1 worker-2; do ssh $i timedatectl set-timezone Asia/Tehran ;done 
    for i in master-1 master-2 master-3 worker-1 worker-2; do ssh $i timedatectl | grep NTP;done
    for i in master-1 master-2 master-3 worker-1 worker-2; do ssh $i date ;done # check date state on all node
#### extra steps for disperse 6 and redundancy 2
    apt install xmlstarlet -y
    XMLSTARLET el -u table.xml
    XMLSTARLET el table.xml
    XMLSTARLET el -v table.xml
    xmlstarlet val  xml.xml
##### tmux way
```