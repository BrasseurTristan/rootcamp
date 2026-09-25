#!/usr/bin/env bash
# Casse : la configuration de l'appli de facturation a disparu de /etc.
# Plusieurs copies traînent ailleurs ; une seule est la bonne.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

rc_user alice

rm -rf /etc/facturation /srv/sauvegardes /var/tmp/essais-facturation
rm -f /home/alice/facturation.conf /tmp/facturation.conf.swp

conf() { # conf <version> <base> <commentaire>
  printf '# Configuration de l'"'"'application de facturation\n# %s\nversion=%s\nbase=%s\nport=8081\nlog=/var/log/facturation.log\n' "$3" "$1" "$2"
}

for mois in 04 05 06; do
  d=/srv/sauvegardes/2025-$mois/etc/facturation
  mkdir -p "$d"
  case $mois in
    04) conf 1 postgres://db01/facturation "sauvegarde du 30/04/2025" > "$d/facturation.conf" ;;
    05) conf 2 postgres://db01/facturation "sauvegarde du 31/05/2025" > "$d/facturation.conf" ;;
    06) conf 3 postgres://db02/facturation "sauvegarde du 30/06/2025" > "$d/facturation.conf" ;;
  esac
  touch -d "2025-$mois-28 02:30" "$d/facturation.conf"
done

# Des leurres
conf 3 postgres://localhost/test "COPIE PERSO D'ALICE POUR SES TESTS — NE PAS UTILISER" > /home/alice/facturation.conf
chown alice:alice /home/alice/facturation.conf
mkdir -p /var/tmp/essais-facturation
conf 4 postgres://db-test/facturation "ENVIRONNEMENT DE TEST" > /var/tmp/essais-facturation/facturation.conf
echo "fichier d'échange de l'éditeur, illisible" > /tmp/facturation.conf.swp

cat > /usr/local/bin/facturation <<'SCRIPT'
#!/bin/sh
# Application de facturation (simulée).
conf=/etc/facturation/facturation.conf
if [ ! -r "$conf" ]; then
  echo "facturation: erreur fatale : impossible de lire $conf" >&2
  exit 1
fi
echo "facturation: configuration chargée ($(grep '^version=' "$conf"), $(grep '^base=' "$conf"))"
SCRIPT
chmod 755 /usr/local/bin/facturation
