#!/usr/bin/env bash
# Prépare : un disque neuf et vierge de 1 Go vient d'être branché. Il faut le
# partitionner, le formater et le monter de façon permanente.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/disques.sh
source "$RC_LIB/disques.sh"

cd /
umount -l /srv/archives 2>/dev/null || true   # même occupé : ce disque ne sert plus
fstab_retirer /srv/archives
systemctl daemon-reload
disque_creer archives 1G >/dev/null
rm -rf /srv/archives
mkdir -p /srv/archives
