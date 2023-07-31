```
qemu-img  convert -O qcow2 /var/lib/libvirt/images/LDAP.qcow2 /Backup/kvm/LDAP---$(date +"%Y-%m-%d--%H-%M").qcow2 -p
```
qemu-img: Could not open '/var/lib/libvirt/images/LDAP.qcow2': Failed to get shared "write" lock
Is another process using the image [/var/lib/libvirt/images/LDAP.qcow2]?

``` qemu-img  convert -O qcow2 /var/lib/libvirt/images/LDAP.qcow2 /Backup/kvm/LDAP---$(date +"%Y-%m-%d--%H-%M").qcow2 -p --force-share ```
