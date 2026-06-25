#!/usr/bin/env bash
# Install WireGuard and generate server keypair.
set -euo pipefail

apt-get update -q && apt-get install -y wireguard

umask 077
wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key

echo "Server private key: $(cat /etc/wireguard/server_private.key)"
echo "Server public key:  $(cat /etc/wireguard/server_public.key)"

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

echo ""
echo "Next steps:"
echo "1. Copy wg0.conf.example → /etc/wireguard/wg0.conf"
echo "2. Replace SERVER_PRIVATE_KEY with: $(cat /etc/wireguard/server_private.key)"
echo "3. Generate peer keys: wg genkey | tee peer_private | wg pubkey > peer_public"
echo "4. Add peers to wg0.conf"
echo "5. systemctl enable --now wg-quick@wg0"
