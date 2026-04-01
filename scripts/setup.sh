#!/bin/bash
# Script d'automatisation - Configuration initiale du serveur
set -e

echo "=== Mise a jour du systeme ==="
apt-get update -y

echo "=== Installation des dependances ==="
apt-get install -y curl wget git

echo "=== Configuration du pare-feu ==="
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
echo "y" | ufw enable

echo "=== Verification des services ==="
systemctl status nginx || echo "Nginx non encore installe"

echo "=== Script termine avec succes ==="
