#!/usr/bin/env bash
# Restore PostgreSQL from latest backup.
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/var/backups/infra-stack}"

LATEST=$(ls -t "$BACKUP_DIR"/postgres_*.sql.gz 2>/dev/null | head -1)
if [[ -z "$LATEST" ]]; then
    echo "No postgres backup found in $BACKUP_DIR"
    exit 1
fi

echo "Restoring from: $LATEST"
read -r -p "Confirm? This will overwrite the database. [y/N] " confirm
[[ "$confirm" == "y" ]] || exit 0

docker compose stop mattermost
gunzip -c "$LATEST" | docker compose exec -T postgres psql \
    -U "${POSTGRES_USER:-mmuser}" \
    -d postgres
docker compose start mattermost

echo "Restore complete."
