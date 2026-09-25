#!/usr/bin/env bash
# Casse : le compte deploy est membre du groupe sudo, donc root sur toute la
# machine, alors qu'il n'a besoin que de lancer le script de déploiement.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

# Supprime les règles sudo laissées par une tentative précédente.
grep -lE '(^|[^a-z])deploy' /etc/sudoers.d/* 2>/dev/null | xargs -r rm -f
sed -i '/^[^#]*deploy/d' /etc/sudoers

rc_user deploy
echo 'deploy:Deploy2026!' | chpasswd
usermod -aG sudo deploy

mkdir -p /opt/appli
cat > /usr/local/bin/deployer-appli <<'SCRIPT'
#!/bin/sh
# Déploie la dernière version de l'application (doit tourner en root).
set -e
[ "$(id -u)" -eq 0 ] || { echo "deployer-appli doit être lancé en root" >&2; exit 1; }
date '+%F %T' > /opt/appli/derniere-version
echo "Déploiement terminé."
SCRIPT
chmod 755 /usr/local/bin/deployer-appli
