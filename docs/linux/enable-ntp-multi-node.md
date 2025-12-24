# Enable NTP on Ubuntu 20 (multi-node)

Ref: `https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-20-04`

```bash
for i in master-1 master-2 master-3 worker-1 worker-2; do ssh $i timedatectl set-timezone Asia/Tehran; done
for i in master-1 master-2 master-3 worker-1 worker-2; do ssh $i timedatectl | grep NTP; done
for i in master-1 master-2 master-3 worker-1 worker-2; do ssh $i date; done
```
