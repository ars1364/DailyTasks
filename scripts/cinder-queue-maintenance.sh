#!/bin/bash
# cinder-queue-maintenance.sh
# Monitors RabbitMQ cinder queues and restarts scheduler if backlog exceeds threshold.
# Intended to run via cron every 30 minutes until Kolla-Ansible redeploy fixes root cause.
#
# Root cause: rabbit_qos_prefetch_count=1 triggers flow control on cinder-scheduler
# connections, causing heartbeat failures and 100K+ message backlog.
# Permanent fix: set rabbit_qos_prefetch_count=10 in /etc/kolla/config/cinder.conf
# and run kolla-ansible reconfigure -t cinder.
#
# Install:
#   chmod +x /opt/cinder-queue-maintenance.sh
#   echo "*/30 * * * * root /opt/cinder-queue-maintenance.sh >> /var/log/cinder-maintenance.log 2>&1" > /etc/cron.d/cinder-maintenance
#
# Remove after permanent fix is applied.

set -euo pipefail

THRESHOLD=5000
LOG_PREFIX="[$(date -u +%Y-%m-%dT%H:%M:%SZ)] cinder-maint:"

log() { echo "${LOG_PREFIX} $*"; }

# Check scheduler fanout queue depth
QUEUE_DEPTH=$(docker exec rabbitmq rabbitmqctl list_queues name messages 2>/dev/null \
    | grep "cinder-scheduler_fanout" \
    | awk '{print $2}' || echo "0")

log "cinder-scheduler_fanout queue depth: ${QUEUE_DEPTH}"

if [ "${QUEUE_DEPTH}" -gt "${THRESHOLD}" ]; then
    log "ALERT: Queue depth ${QUEUE_DEPTH} exceeds threshold ${THRESHOLD}"

    # Purge stale messages
    log "Purging cinder-scheduler_fanout..."
    docker exec rabbitmq rabbitmqctl purge_queue cinder-scheduler_fanout 2>/dev/null || true
    docker exec rabbitmq rabbitmqctl purge_queue scheduler_fanout 2>/dev/null || true
    log "Queues purged"

    # Restart cinder-scheduler
    log "Restarting cinder_scheduler..."
    docker restart cinder_scheduler 2>/dev/null || true
    sleep 5

    # Restart cinder-volume to refresh RPC connections
    log "Restarting cinder_volume..."
    docker restart cinder_volume 2>/dev/null || true
    sleep 10

    # Verify
    NEW_DEPTH=$(docker exec rabbitmq rabbitmqctl list_queues name messages 2>/dev/null \
        | grep "cinder-scheduler_fanout" \
        | awk '{print $2}' || echo "unknown")
    log "Post-restart queue depth: ${NEW_DEPTH}"
else
    log "OK: Queue depth within threshold"
fi

# Also check for stuck volumes older than 1 hour
DBPASS=$(grep ^database_password /etc/kolla/passwords.yml 2>/dev/null | awk '{print $2}')
if [ -n "${DBPASS}" ]; then
    STUCK=$(docker exec mariadb mysql -u root -p${DBPASS} -N -e \
        "SELECT COUNT(*) FROM cinder.volumes WHERE status='creating' AND created_at < NOW() - INTERVAL 1 HOUR;" 2>/dev/null || echo "0")
    if [ "${STUCK}" -gt "0" ]; then
        log "ALERT: ${STUCK} volumes stuck in 'creating' > 1 hour. Resetting to 'error'."
        docker exec mariadb mysql -u root -p${DBPASS} -e \
            "UPDATE cinder.volumes SET status='error' WHERE status='creating' AND created_at < NOW() - INTERVAL 1 HOUR;" 2>/dev/null || true
    else
        log "OK: No stuck volumes"
    fi
fi

log "Done"
