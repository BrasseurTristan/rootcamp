#!/usr/bin/env bash
set -euo pipefail
d2=$(losetup -j /var/lib/rootcamp/disques/bdd2.img -O NAME -n)
pvcreate -q -y "$d2"
vgextend -q vg_donnees "$d2"
lvextend -q -r -l +100%FREE vg_donnees/postgres
