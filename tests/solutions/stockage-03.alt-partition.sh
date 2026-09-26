#!/usr/bin/env bash
# Le second disque est partitionné (type LVM) avant de servir de volume
# physique : /dev/loopNp1 au lieu du disque entier.
set -euo pipefail
d2=$(losetup -j /var/lib/rootcamp/disques/bdd2.img -O NAME -n)
echo ',,8e' | sfdisk -q "$d2"
partx -u "$d2" 2>/dev/null || true
for _ in $(seq 20); do [[ -b ${d2}p1 ]] && break; sleep 0.5; done
pvcreate -q -y "${d2}p1"
vgextend -q vg_donnees "${d2}p1"
lvextend -q -r -l +100%FREE vg_donnees/postgres
