#!/usr/bin/env bash
# Le volume logique grandit, mais pas le système de fichiers : df ne voit rien.
set -euo pipefail
d2=$(losetup -j /var/lib/rootcamp/disques/bdd2.img -O NAME -n)
pvcreate -q -y "$d2"
vgextend -q vg_donnees "$d2"
lvextend -q -l +100%FREE vg_donnees/postgres
