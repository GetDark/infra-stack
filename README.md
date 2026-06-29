[English](#english) | [Русский](#русский)

---

<a name="english"></a>
# infra-stack

Self-hosted team infrastructure: Mattermost (team chat) + PostgreSQL + nginx (SSL termination) + WireGuard VPN — all in Docker Compose.

## Stack

| Service | Image | Port |
|---------|-------|------|
| Mattermost | `mattermost/mattermost-team-edition:9.10` | 8065 (internal) |
| PostgreSQL | `postgres:16-alpine` | internal |
| nginx | `nginx:1.27-alpine` | 80, 443 |
| WireGuard | — | setup via script |

All services communicate over an internal Docker bridge network. nginx handles SSL and proxies to Mattermost.

## Quick Start

```bash
git clone https://github.com/GetDark/infra-stack.git
cd infra-stack

cp .env.example .env
nano .env  # set POSTGRES_PASSWORD and SITE_URL

docker compose up -d
```

## WireGuard VPN

```bash
bash wireguard/setup.sh
cp wireguard/wg0.conf.example /etc/wireguard/wg0.conf
# edit wg0.conf with your keys, then:
wg-quick up wg0
```

## Backup & Restore

```bash
bash scripts/backup.sh    # creates backup archive
bash scripts/restore.sh   # restores from archive
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `POSTGRES_PASSWORD` | **Required.** Database password |
| `POSTGRES_USER` | DB user (default: `mmuser`) |
| `POSTGRES_DB` | DB name (default: `mattermost`) |
| `SITE_URL` | Mattermost public URL (e.g. `https://chat.example.com`) |

---

<a name="русский"></a>
# infra-stack

Самостоятельно размещаемая командная инфраструктура: Mattermost (командный чат) + PostgreSQL + nginx (SSL) + WireGuard VPN — всё в Docker Compose.

## Стек

| Сервис | Образ | Порт |
|--------|-------|------|
| Mattermost | `mattermost/mattermost-team-edition:9.10` | 8065 (внутренний) |
| PostgreSQL | `postgres:16-alpine` | внутренний |
| nginx | `nginx:1.27-alpine` | 80, 443 |
| WireGuard | — | настройка через скрипт |

Все сервисы общаются через внутреннюю Docker bridge-сеть. nginx терминирует SSL и проксирует запросы на Mattermost.

## Быстрый старт

```bash
git clone https://github.com/GetDark/infra-stack.git
cd infra-stack

cp .env.example .env
nano .env  # задать POSTGRES_PASSWORD и SITE_URL

docker compose up -d
```

## WireGuard VPN

```bash
bash wireguard/setup.sh
cp wireguard/wg0.conf.example /etc/wireguard/wg0.conf
# отредактировать wg0.conf со своими ключами, затем:
wg-quick up wg0
```

## Резервное копирование

```bash
bash scripts/backup.sh    # создаёт архив резервной копии
bash scripts/restore.sh   # восстанавливает из архива
```

## Переменные окружения

| Переменная | Описание |
|------------|----------|
| `POSTGRES_PASSWORD` | **Обязательна.** Пароль базы данных |
| `POSTGRES_USER` | Пользователь БД (по умолчанию: `mmuser`) |
| `POSTGRES_DB` | Имя БД (по умолчанию: `mattermost`) |
| `SITE_URL` | Публичный URL Mattermost (например `https://chat.example.com`) |
