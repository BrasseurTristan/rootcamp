#!/usr/bin/env bash
# Casse : le volume LVM de la base de données est plein, et le groupe de
# volumes n'a presque plus de place. Un second disque vierge est disponible.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/disques.sh
source "$RC_LIB/disques.sh"

umount -l /srv/bdd 2>/dev/null || true
fstab_retirer /srv/bdd
vgremove -ff -y vg_donnees &>/dev/null || true
disque_supprimer bdd1
disque_supprimer bdd2
d1=$(disque_creer bdd1 400M)
disque_creer bdd2 600M >/dev/null

pvcreate -q -y "$d1" >/dev/null
vgcreate -q vg_donnees "$d1" >/dev/null
lvcreate -q -y -n postgres -L 300M vg_donnees >/dev/null
mkfs.ext4 -q -L postgres /dev/vg_donnees/postgres
mkdir -p /srv/bdd
mount /dev/vg_donnees/postgres /srv/bdd
echo "/dev/vg_donnees/postgres /srv/bdd ext4 defaults,nofail 0 2" >> /etc/fstab
systemctl daemon-reload

mkdir -p /srv/bdd/base
head -c 2M /dev/urandom > /srv/bdd/base/clients.db
( cd /srv/bdd && sha256sum base/clients.db ) > /var/lib/rootcamp/stockage-03.sha256
fallocate -l 250M /srv/bdd/base/factures.db
