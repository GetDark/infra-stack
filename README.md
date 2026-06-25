# infra-stack

Internal team infrastructure on Docker Compose: **Mattermost** (team chat) + **PostgreSQL** + **nginx** reverse proxy with SSL + **WireGuard** VPN + automated backups.

## Services

| Service | Port | Purpose |
|---------|------|---------|
| Mattermost | 8065 (internal) | Team messenger |
| PostgreSQL | internal | Mattermost database |
| nginx | 80, 443 | Reverse proxy + SSL termination |
| WireGuard | 51820 UDP | VPN access to internal services |

## Quick Start

```bash
# 1. Copy and fill env
cp .env.example .env
vim .env  # set POSTGRES_PASSWORD and SITE_URL

# 2. Obtain SSL cert (before starting nginx)
certbot certonly --standalone -d chat.yourdomain.com

# 3. Update nginx config
sed -i 's/chat.yourdomain.com/YOUR_DOMAIN/g' nginx/conf.d/mattermost.conf

# 4. Start stack
docker compose up -d

# 5. Check health
docker compose ps
curl https://chat.yourdomain.com/api/v4/system/ping
```

## WireGuard VPN

```bash
# Setup server
bash wireguard/setup.sh

# Copy config and edit
cp wireguard/wg0.conf.example /etc/wireguard/wg0.conf
vim /etc/wireguard/wg0.conf  # replace keys

# Enable
systemctl enable --now wg-quick@wg0
```

Peers connect over VPN and access internal services (Mattermost at 10.0.0.1:8065) without exposing ports publicly.

## Backup

```bash
# Manual
bash scripts/backup.sh

# Cron (daily 03:00)
echo "0 3 * * * cd /opt/infra-stack && bash scripts/backup.sh" | crontab -

# Restore from latest postgres dump
bash scripts/restore.sh
```

## nginx websocket support

The nginx config handles Mattermost websocket connections (`/api/v*/websocket`) with `Upgrade` headers and `proxy_read_timeout 86400` — required for real-time messaging.
