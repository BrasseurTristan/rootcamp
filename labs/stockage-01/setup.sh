#!/usr/bin/env bash
# Casse : la partition /srv/donnees est pleine. Deux causes : de vieux exports
# temporaires, et un fichier supprimé mais toujours ouvert par un processus.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/disques.sh
source "$RC_LIB/disques.sh"

systemctl stop exporteur &>/dev/null || true
systemctl reset-failed exporteur &>/dev/null || true
disque_supprimer donnees
dev=$(disque_creer donnees 200M)
mkfs.ext4 -q -L donnees "$dev"
mkdir -p /srv/donnees
mount "$dev" /srv/donnees

d=/srv/donnees
mkdir -p "$d/bilans" "$d/exports/tmp"
for an in 2023 2024 2025; do head -c 1M /dev/urandom > "$d/bilans/bilan-$an.pdf"; done
head -c 5M /dev/urandom > "$d/exports/export-2025-09.csv"
( cd "$d" && sha256sum bilans/* exports/export-2025-09.csv ) > /var/lib/rootcamp/stockage-01.sha256
for mois in 01 02 03 04 05 06; do
  fallocate -l 18M "$d/exports/tmp/export-2024-$mois.csv.gz"
  touch -d "2024-$mois-28" "$d/exports/tmp/export-2024-$mois.csv.gz"
done

# L'export nocturne : il écrit un gros journal temporaire, puis reste en attente
# en gardant le fichier ouvert. Quelqu'un a supprimé le fichier entre-temps.
systemd-run --quiet --unit=exporteur --description="Export nocturne de la compta" \
  sh -c 'exec 3>/srv/donnees/exports/journal-export.tmp; head -c 60M /dev/zero >&3; exec sleep infinity'
rc_retry 10 sh -c '[ "$(stat -c %s /srv/donnees/exports/journal-export.tmp 2>/dev/null)" = 62914560 ]'
rm -f "$d/exports/journal-export.tmp"
