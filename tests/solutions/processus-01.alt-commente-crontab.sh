#!/usr/bin/env bash
# Commenter la ligne de la crontab plutôt que la supprimer, avec le script
# encore ouvert dans un « less » (qui ne doit pas compter comme lancé).
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$(dirname "$0")/../../lib/lab.sh"
sed -i 's|^@reboot|#@reboot|' /var/spool/cron/crontabs/bob
for p in $(rc_pids /opt/outils/surveillant); do kill "$p"; done
sleep 0.5
for p in $(rc_pids /opt/outils/indexeur); do kill "$p"; done
setsid timeout 60 bash -c 'exec -a less tail /opt/outils/surveillant -f' </dev/null >/dev/null 2>&1 &
