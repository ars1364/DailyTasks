# Ubuntu 20.04 image preparation for Glance

Source image:
`https://cloud-images.ubuntu.com/releases/focal/release/`

```bash
wget http://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img
qemu-img resize ubuntu-20.04-server-cloudimg-amd64.img 5G
qemu-img info ubuntu-20.04-server-cloudimg-amd64.img
```

## Mount qcow2 and resize
Ref: `https://gist.github.com/shamil/62935d9b456a6f9877b5`

```bash
modprobe nbd max_part=8
qemu-nbd --connect=/dev/nbd0 ubuntu-20.04-server-cloudimg-amd64.img
lsblk
mount /dev/nbd0p1 /mnt
growpart /dev/nbd0 1
resize2fs /dev/nbd0p1
df -h
chroot /mnt
```

## Customization
```bash
cat > /etc/motd <<EOF
EOF

mkdir -p ../run/systemd/resolve/
touch ../run/systemd/resolve/stub-resolv.conf
echo "nameserver 1.1.1.1" > ../run/systemd/resolve/stub-resolv.conf

apt update
apt upgrade -y

echo "base_reachable_time_ms = 300000" > /etc/sysctl.d/10-arp.conf

cat > /etc/cloud/cloud.cfg.d/ubuntu.cfg <<EOF
bootcmd:
   - sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
   - sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
disable_root: False
resize_rootfs: True
users:
  - name: ubuntu
    shell: /bin/false
    no-create-home: True
    no-user-group: True
  - name: root
    ssh_pwauth: True
    shell: /bin/bash
    lock-passwd: false
chpasswd:
  list: |
    root:Paas!@#123
  expire: True
runcmd:
  - [ deluser, ubuntu ]
packages:
 - net-tools
 - sudo
 - nano
EOF

exit
> /mnt/root/.bash_history
umount /mnt
qemu-nbd --disconnect /dev/nbd0
```

## Convert and upload to Glance
```bash
qemu-img convert -p -O raw ubuntu-20.04-server-cloudimg-amd64.img ubuntu20.04.raw
glance image-create --name "ubuntu-20-new" --file ubuntu20.04.raw --disk-format raw --container-format bare --progress
```
