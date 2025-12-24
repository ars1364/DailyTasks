# DailyTasks

Operations notes and scripts collected from day-to-day troubleshooting. This repo is
documentation first, with a small set of utility scripts used in specific environments.

## Structure
- `docs/networking`: OVN and Open vSwitch notes.
- `docs/storage`: partition, filesystem, and LVM runbooks.
- `docs/virtualization`: qemu and libvirt notes.
- `scripts/backup`: ad-hoc backup automation.
- `scripts/ceph`: Ceph operational helpers.
- `scripts/cluster`: cluster recovery helpers.
- `scripts/qos`: IO tuning helpers.
- `scripts/vpn`: VPN setup scripts.

## Docs index
- `docs/networking/ovn-allocate-network-error.md`: OVN AllocateNetworkError commands and logs.
- `docs/storage/extend-linux-partition.md`: grow partition and filesystem (LVM and non-LVM).
- `docs/virtualization/qemu-convert-issue.md`: qemu-img lock issue and fix.

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
