# Ceph-ansible failed to fetch key (release.asc)

Error:
```text
TASK [ceph-common : configure red hat ceph community repository stable key]
FAILED - RETRYING: configure red hat ceph community repository stable key (3 retries left).
FAILED - RETRYING: configure red hat ceph community repository stable key (2 retries left).
FAILED - RETRYING: configure red hat ceph community repository stable key (1 retries left).
fatal: [osd100]: FAILED! => changed=false
  attempts: 3
  msg: 'failed to fetch key at https://download.ceph.com/keys/release.asc , error was: Request failed: <urlopen error [Errno -2] Name or service not known>'
```

## Solution 1
```bash
rpm --import 'https://download.ceph.com/keys/release.asc'
```

## Solution 2
- Check internet access on the ceph deployer and target storage host.
- Reinstall `ca-certificate` on the target host.
