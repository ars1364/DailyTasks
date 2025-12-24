# Useful commands: Virtualization

```text
virt-mgr
virsh secret-define --file secret.xml
#hw_qemu_guest_agent=yes: enable the QEMU guest agent
#os_require_quiesce=yes: send fs-freeze/thaw calls through the QEMU guest agent
copy image to /var/lib/libvirt/images/
add NIC one by one to machine using virt-manager
shut down LDAP machine, apply network config using virsh edit then start and config IP either netplan() as permanent way or ifconfig as temp way
################NoVNC Upgrade
https://ilearnedhowto.wordpress.com/tag/novnc/
novncproxy_base_url = https://79.127.117.114:6080/vnc_lite.html
wget https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz -O novnc-v1.1.3.tar.gz
tar xfz novnc-v1.1.3.tar.gz
mv /usr/share/novnc /usr/share/novnc-bak2
mv /media/noVNC-1.3.0/ /usr/share/novnc
cd /usr/share/novnc
mv vnc_lite.html vnc_auto.html
RewriteRule !^vnc_lite\.html vnc_lite.html [F,NC]
https://libvirt.org/formatdomain.html
virsh attach-disk dbcf6674-555d-4a63-8c78-f451d04c85e3  /dev/sdg vdb  --cache none --persistent
grep -r iops /etc/libvirt
grep -r -A 5 \<iotune /etc/libvirt
for i in $(ls /etc/libvirt/qemu/*.xml); do virt-xml-validate $i && echo $i;done
for i in $(ls /etc/libvirt/qemu/*.xml); do xmllint --noout $i && echo $i;done
virsh dumpxml vm_name > vm_name.xml
virsh define vm_name.xml
virsh list --all --persistent
virsh dominfo vm_name
virsh domiflist instance-000026a3
virsh domifstat instance-000026a3 --interface tap38ee9941-72
https://www.libvirt.org/manpages/virsh.html#id69
virsh dumpxml instance-00003f11 | grep iops -C 5
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
https://manpages.debian.org/bullseye/libvirt-clients/virsh.1.en.html
#########esx
/vmfs/volumes/datastore1
#fix resolve in esx ssh
[root@datacentername:/vmfs/volumes/63a8693b-9be46d50-9628-1c98ec16e858] wget "http://releases.ubuntu.com/focal/ubuntu-20.04.5-live-server-amd64.iso"
virsh edit instance-0000a01c
qemu-img info /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-93
qemu-img convert -p -O raw -f qcow2 volume.qcow2 /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-93
qemu-img info /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-93
qemu-img convert -p -O raw -f qcow2 carpo-01.qcow2 /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-130
qemu-img convert -p -f raw /dev/disk/by-path/pci-0000:08:00.0-fc-0x5006016136e03668-lun-130  -O qcow2 carpo-01.qcow2
virsh domstats | grep -E ".*block.*.path|instance" | awk -F'[=]' '{print $2}'
#### xml parser used for qemu diaster backup to parse virsh dumpxml file
    for k in s3 s4 s6 s8 s9 s12 s13 s14 s15 s20; do echo $k && for i in $(ssh $k virsh list | grep instance | awk '{print $2}') ;do echo 'instance name-->'$i && for j in $(ssh $k virsh domblklist $i | grep .| grep -v -E 'Target|\-\-' | awk '{print $2}');do ssh $k  qemu-img info $j ;done;done;done
```