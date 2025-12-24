# DailyTasks

Operations notes and scripts collected from day-to-day troubleshooting. This repo is
documentation first, with a small set of utility scripts used in specific environments.

## Structure
- `docs/apps`: application runbooks.
- `docs/ceph`: Ceph troubleshooting notes.
- `docs/cheatsheets`: quick command references.
- `docs/cluster`: cluster recovery runbooks.
- `docs/linux`: Linux admin notes.
- `docs/networking`: OVN and Open vSwitch notes.
- `docs/openstack`: OpenStack notes and image prep.
- `docs/storage`: partition, filesystem, and LVM runbooks.
- `docs/virtualization`: qemu and libvirt notes.
- `docs/windows`: Windows image prep and notes.
- `scripts/backup`: ad-hoc backup automation.
- `scripts/ceph`: Ceph operational helpers.
- `scripts/cluster`: cluster recovery helpers.
- `scripts/qos`: IO tuning helpers.
- `scripts/vpn`: VPN setup scripts.

## Docs index
- `docs/apps/nextcloud-php-ops.md`: Nextcloud PHP troubleshooting notes.
- `docs/ceph/ceph-ansible-key-fetch.md`: ceph-ansible key fetch failure fix.
- `docs/cheatsheets/bash-notes.md`: bash error patterns and quick fixes.
- `docs/cheatsheets/useful-commands.md`: large raw commands list (migrated).
- `docs/cluster/galera-recovery.md`: Galera recovery steps in Pacemaker.
- `docs/linux/enable-ntp-multi-node.md`: enable NTP across Ubuntu nodes.
- `docs/linux/remote-host-append-hosts.md`: remote /etc/hosts append snippet.
- `docs/networking/ovn-allocate-network-error.md`: OVN AllocateNetworkError commands and logs.
- `docs/networking/mikrotik-edge-router.md`: MikroTik edge router notes.
- `docs/networking/find-unknown-mac.md`: locate unknown MAC address.
- `docs/openstack/commands.md`: OpenStack operational commands.
- `docs/openstack/ubuntu-20-04-image-prep.md`: Ubuntu 20.04 image prep.
- `docs/openstack/windows-image-prep.md`: Windows image prep for Glance.
- `docs/storage/extend-linux-partition.md`: grow partition and filesystem (LVM and non-LVM).
- `docs/virtualization/qemu-convert-issue.md`: qemu-img lock issue and fix.
- `docs/windows/windows-2012-image-prep.md`: Windows 2012 image prep.

## Scripts index
- `scripts/backup/eco-qemu-disaster-backup.sh`: backup QEMU volumes from Ceph (eco pool).
- `scripts/backup/san-disaster-backup.sh`: backup QEMU volumes from SAN-backed instances.
- `scripts/ceph/restart-osd-service.sh`: restart ceph-osd services on target nodes.
- `scripts/cluster/restart-galera-bundle.sh`: recover a Galera bundle using highest seqno.
- `scripts/qos/bus-set-iotune.sh`: apply IO limits to instances with exception list.
- `scripts/qos/set-eco-deviotune.sh`: apply IO limits to economy compute nodes.
- `scripts/vpn/wireguard-install.sh`: WireGuard installer (third-party, see script header).

## Notes
- Scripts are environment-specific. Review before running and adapt hostnames, pools,
  and paths to match your setup.
