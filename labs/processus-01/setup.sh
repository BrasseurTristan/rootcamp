#!/usr/bin/env bash
# Casse : un « indexeur » bloqué dans une boucle mange 100 % d'un CPU. Il est
# relancé par un script surveillant dès qu'on le tue, et le surveillant est
# lui-même relancé à chaque démarrage par la crontab de bob.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

rc_user bob   # tue aussi les processus d'une tentative précédente

mkdir -p /opt/outils
cat > /opt/outils/indexeur <<'SCRIPT'
#!/bin/sh
# Indexeur de documents (bogué : boucle infinie).
while :; do :; done
SCRIPT
cat > /opt/outils/surveillant <<'SCRIPT'
#!/bin/sh
# Relance l'indexeur s'il s'arrête.
pid=
while true; do
  if [ -z "$pid" ] || ! kill -0 "$pid" 2>/dev/null; then
    /opt/outils/indexeur &
    pid=$!
  fi
  sleep 2
done
SCRIPT
chmod 755 /opt/outils/indexeur /opt/outils/surveillant

# La crontab de bob relance le surveillant à chaque démarrage.
spool=/var/spool/cron/crontabs
mkdir -p "$spool"
echo "@reboot /opt/outils/surveillant" > "$spool/bob"
chown bob "$spool/bob"
chgrp crontab "$spool/bob" 2>/dev/null || true
chmod 600 "$spool/bob"

runuser -u bob -- setsid /opt/outils/surveillant </dev/null >/dev/null 2>&1 &
indexeur_tourne() { [[ -n $(rc_pids /opt/outils/indexeur) ]]; }
rc_retry 5 indexeur_tourne
