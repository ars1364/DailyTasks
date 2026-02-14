# Incident Report: Cinder Volume Creation Stuck in "Creating"

**Date:** 2026-02-14  
**Severity:** Critical  
**Affected Service:** Cinder (Block Storage)  
**Cluster:** aries.cloudinative.com (Kolla-Ansible, OpenStack 2025.1 Epoxy)  
**Duration:** Feb 11 23:29 UTC (last successful volume) → Feb 14 (ongoing)

---

## Symptoms

- All volume creation requests stuck indefinitely in "creating" status
- Volumes never transition to "available" or "error"
- 4+ orphaned volumes in "creating" state in MariaDB
- No errors visible in Cinder API responses (HTTP 202 accepted)

## Investigation Timeline

| Time (UTC) | Event |
|---|---|
| Feb 11 23:29 | Last successful volume creation (`b3bb9dd1`) |
| Feb 13 06:17 | RabbitMQ flow control events begin (`connection.blocked`) |
| Feb 13 06:40 | Heartbeat failures cascade across all 3 control nodes |
| Feb 14 10:42 | First stuck volume reported (`52a49a2c`) |
| Feb 14 11:51 | cinder_volume container restarted (did not fix issue) |
| Feb 14 13:20 | Root cause investigation began |

## Root Cause Analysis

### Chain of Failure

```
Low prefetch count (1)
    → RabbitMQ flow control activates on cinder-scheduler connections
        → Blocked TCP connections cannot send heartbeat frames
            → RabbitMQ kills connections after 60s timeout
                → cinder-scheduler reconnects immediately
                    → 100,959 messages pile up in scheduler_fanout queue
                        → Scheduler spends all time reconnecting, not processing
                            → Volume requests never dispatched to cinder-volume
                                → Volumes stuck in "creating" forever
```

### Root Cause: RabbitMQ Flow Control + Low Prefetch Count

**Configuration issue:** `rabbit_qos_prefetch_count = 1` (default) in oslo.messaging.

With prefetch=1, cinder-scheduler can only fetch one message at a time from RabbitMQ. Under normal Cinder scheduling load, this triggers RabbitMQ's flow control mechanism, which **blocks the entire TCP connection** -- including heartbeat frames.

### Evidence

#### Flow Control Events (RabbitMQ log on server01)
```
2026-02-13 06:17:27 [error] {<<"connection.blocked">>,bool,true}
2026-02-13 06:20:28 [error] {<<"connection.blocked">>,bool,true}
2026-02-13 06:23:29 [error] {<<"connection.blocked">>,bool,true}
2026-02-13 06:26:30 [error] {<<"connection.blocked">>,bool,true}
```
Pattern: flow control every ~3 minutes, matching heartbeat timeout cycles.

#### Service-Specific Impact
| Service | Heartbeat Failures (Feb 13) | Affected? |
|---|---|---|
| cinder-scheduler | 3,185 | YES |
| cinder-volume | 265 | YES |
| nova-conductor | 0 | NO |
| neutron-server | 0 | NO |
| heat-engine | 0 | NO |

Only Cinder affected -- it has the highest message volume on scheduler fanout queues.

#### Connection Churn
- 3,585 new AMQP connections on Feb 13 (abnormal)
- Each failed connection duration: exactly `3M, 0s` (180s = 3 heartbeat cycles)
- Issue ongoing since at least Feb 1 (not a sudden event -- gradual degradation)

#### Queue Backlog
```
cinder-scheduler_fanout: 100,959 messages / 3 consumers
scheduler_fanout:         16,784 messages / 15 consumers
```

#### Performance Layer Analysis
| Layer | Measured Latency | Status |
|---|---|---|
| Cinder API | 0.45s | Healthy |
| Ceph RBD direct create | 0.155s | Healthy |
| Ceph RBD direct delete | 0.256s | Healthy |
| Cinder Scheduler dispatch | 120s+ (never completes) | **BROKEN** |
| Cinder Volume manager | Never reached | Blocked by scheduler |

### Contributing Factors

1. **Single scheduler:** Only server01 runs cinder-scheduler (no HA)
2. **System load:** server01 at 7.39 load avg, RabbitMQ at 517% CPU
3. **QEMU pressure:** VM instances consuming 169%+ CPU on control node
4. **No queue TTL:** Messages accumulate indefinitely

## Immediate Mitigation (No Kolla-Ansible Redeploy)

### Step 1: Purge Stale Queues
```bash
sudo docker exec rabbitmq rabbitmqctl purge_queue cinder-scheduler_fanout
sudo docker exec rabbitmq rabbitmqctl purge_queue scheduler_fanout
```

### Step 2: Reset Stuck Volumes in MariaDB
```bash
# Get MariaDB password
DBPASS=$(sudo grep ^database_password /etc/kolla/passwords.yml | awk '{print $2}')

# Reset stuck volumes to error state
sudo docker exec mariadb mysql -u root -p${DBPASS} -e \
  "UPDATE cinder.volumes SET status='error' WHERE status='creating' AND created_at < NOW() - INTERVAL 1 HOUR;"
```

### Step 3: Restart Cinder Services
```bash
sudo docker restart cinder_scheduler
sudo docker restart cinder_volume
# On server02 and server03:
ssh server02 "sudo docker restart cinder_scheduler 2>/dev/null; true"
ssh server03 "sudo docker restart cinder_scheduler 2>/dev/null; true"
```

### Step 4: Verify
```bash
# Check queue depths (should be near zero)
sudo docker exec rabbitmq rabbitmqctl list_queues name messages consumers | grep cinder

# Create test volume
# (use the API or Horizon to create a 1GB empty volume -- should complete in <5s)
```

### Step 5: Schedule Recurring Maintenance
See: `scripts/cinder-queue-maintenance.sh`

Runs every 30 minutes via cron to monitor queue depth and restart scheduler if backlog exceeds threshold.

## Permanent Fix (Requires Kolla-Ansible Redeploy)

### Configuration Change

Create/update `/etc/kolla/config/cinder.conf`:
```ini
[oslo_messaging_rabbit]
rabbit_qos_prefetch_count = 10
heartbeat_timeout_threshold = 120
kombu_reconnect_delay = 5.0
rabbit_retry_interval = 1
rabbit_retry_backoff = 2
rabbit_max_retries = 0
```

### Deploy
```bash
kolla-ansible -i /path/to/inventory reconfigure -t cinder
```

### Architecture Improvement
- Deploy cinder-scheduler on server02 and server03 (HA + load distribution)
- Add RabbitMQ queue TTL policy to prevent infinite message accumulation:
  ```bash
  sudo docker exec rabbitmq rabbitmqctl set_policy TTL ".*_fanout" \
    '{"message-ttl":3600000}' --apply-to queues
  ```

## Affected Resources (Cleanup Required)

| Resource | ID | Status | Action |
|---|---|---|---|
| Volume | `52a49a2c` | Force-deleted | Done |
| Volume | `c93de16d` | Force-deleted | Done |
| Volume | `16909df6` | Stuck creating | Reset to error, then delete |
| Port | `2fe7dea1` | Orphaned on 46.245.69.219 | Delete |
| Image | `d20831da` (AlmaLinux-9.7-raw) | Active | Keep (useful) |

## Additional Finding: Dead Volume Backends

Three legacy cinder-volume backends were registered as `enabled` but `down` since Aug-Oct 2025:

| Host | State | Last Updated |
|---|---|---|
| rbd:volumes@rbd-1 | down | 2025-10-08 |
| rbd:volumes@volume-ssd | down | 2025-08-30 |
| rbd:volumes@volume-hdd | down | 2025-08-30 |

These caused the scheduler to log warnings on every scheduling cycle, generating additional unnecessary message traffic. **Disabled** via API on Feb 14.

Active backends (healthy):
- `rbd:volumes@bus` (SSD pool)
- `rbd:volumes@eco` (HDD pool)

**Action taken:** `PUT /v3/os-services/disable` for all 3 dead backends.  
**Permanent fix:** Remove from DB during next maintenance window.

## Quorum Queue Purge Issue

RabbitMQ quorum queues cannot be purged with `rabbitmqctl purge_queue` (returns "not_supported"). The workaround is:
1. Stop all consumers (cinder_scheduler, cinder_volume)
2. Delete the queue with `rabbitmqctl delete_queue`
3. Restart consumers (queues are auto-recreated)

## Resolution Summary

After applying all immediate mitigations:
- **Empty 1GB volume creation: 2.9 seconds** (was: infinite/stuck)
- Queue depth: 90 messages (was: 101,567)
- All orphaned volumes and ports cleaned up
- Maintenance cron installed at `/opt/cinder-queue-maintenance.sh` (runs every 30 min)

## Lessons Learned

1. **Default oslo.messaging settings are not safe for production.** `rabbit_qos_prefetch_count=1` is too low for any service with significant message volume.
2. **Single cinder-scheduler is a single point of failure.** Always deploy on multiple control nodes.
3. **Monitor RabbitMQ queue depths.** A backlog > 1000 messages is an early warning sign.
4. **cinder_volume being "running" does not mean it is "working."** The service appeared healthy but was starved of messages.
5. **Check Cinder logs holistically.** The last log entry was Feb 11 -- 3 days of silence should have been an alert.
