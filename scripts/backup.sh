#!/usr/bin/env bash
# Backup Mattermost data + PostgreSQL. Cron: 0 3 * * *
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/var/backups/infra-stack}"
DATE=$(date +%Y-%m-%d_%H-%M)
RETENTION_DAYS=7

mkdir -p "$BACKUP_DIR"

# PostgreSQL dump via Docker
if docker compose ps postgres | grep -q "running"; then
    docker compose exec -T postgres pg_dumpall \
        -U "${POSTGRES_USER:-mmuser}" \
        | gzip > "$BACKUP_DIR/postgres_${DATE}.sql.gz"
    echo "[backup] postgres: OK"
else
    echo "[backup] postgres: not running"
fi

# Mattermost data directory
if [[ -d "$(docker volume inspect infra-stack_mattermost_data --format '{{.Mountpoint}}')" ]]; then
    VOL=$(docker volume inspect infra-stack_mattermost_data --format '{{.Mountpoint}}')
    tar -czf "$BACKUP_DIR/mattermost_data_${DATE}.tar.gz" -C "$VOL" . 2>/dev/null
    echo "[backup] mattermost data: OK"
fi

# Cleanup
find "$BACKUP_DIR" -name "*.gz" -mtime +"$RETENTION_DAYS" -delete
echo "[backup] DONE $(date) — retention: ${RETENTION_DAYS}d"
