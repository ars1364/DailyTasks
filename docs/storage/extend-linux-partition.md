# Extend and grow Linux partition and filesystem

Thanks to my friend @MortyTech for sharing this and for the help.

## Non-LVM example
Use `fdisk` to delete and recreate the partition, or install `cloud-utils-growpart`
to use `growpart`.

```bash
sudo growpart /dev/sda 1
sudo resize2fs /dev/sda1
```

## LVM example
Example layout:

| Device           | Type               |
| ---------------- | ------------------ |
| /dev/vda2        | LVM PhysicalVolume |
| centos           | LVM VolumeGroup    |
| /dev/centos/root | LVM LogicalVolume  |

If `growpart` is available:

```bash
growpart /dev/vda 2
pvresize -v /dev/vda2
lvextend -l +100%FREE /dev/centos/root
xfs_growfs /dev/centos/root
```

If you are using ext4 instead of xfs:

```bash
resize2fs /dev/centos/root
```

Leave 2% free space for snapshots:

```bash
lvextend -l +98%FREE /dev/centos/root
```
