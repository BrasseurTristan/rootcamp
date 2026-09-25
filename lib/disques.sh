# shellcheck shell=bash
# Disques virtuels des labs du module 05 : des fichiers images attachés comme
# périphériques de bloc (« loop »). Pour Linux, ce sont de vrais disques :
# on peut les partitionner, les formater, y mettre du LVM…

DISQUES=/var/lib/rootcamp/disques

# disque_dev <nom> : périphérique actuel du disque (/dev/loopN), vide s'il n'est pas attaché.
disque_dev() { losetup -j "$DISQUES/$1.img" -O NAME -n 2>/dev/null | head -n1; }

# disque_creer <nom> <taille> : crée un disque vierge et affiche son périphérique.
disque_creer() {
  local nom=$1 taille=$2
  disque_supprimer "$nom"
  mkdir -p "$DISQUES"
  truncate -s "$taille" "$DISQUES/$nom.img"
  _disques_service
  losetup --find --show --partscan "$DISQUES/$nom.img"
}

# disque_supprimer <nom> : démonte tout ce qui vient du disque (partitions,
# volumes LVM), supprime les groupes LVM qui l'utilisent, puis le détache.
disque_supprimer() {
  local nom=$1 dev name target vg
  while read -r dev; do
    [[ -n $dev ]] || continue
    for name in $(lsblk -lnpo NAME "$dev" 2>/dev/null | tac); do
      for target in $(findmnt -rn -S "$name" -o TARGET 2>/dev/null); do
        umount -l "$target" 2>/dev/null || true
      done
    done
    if command -v pvs >/dev/null; then
      # shellcheck disable=SC2046 # une liste de périphériques
      for vg in $(pvs --noheadings -o vg_name $(lsblk -lnpo NAME "$dev") 2>/dev/null | sort -u); do
        vgremove -ff -y "$vg" &>/dev/null || true
      done
      # shellcheck disable=SC2046
      pvremove -ff -y $(lsblk -lnpo NAME "$dev") &>/dev/null || true
    fi
    losetup -d "$dev" 2>/dev/null || true
  done < <(losetup -j "$DISQUES/$nom.img" -O NAME -n 2>/dev/null)
  rm -f "$DISQUES/$nom.img"
}

# fstab_retirer <point de montage> : supprime les lignes de /etc/fstab qui le concernent.
fstab_retirer() {
  awk -v mp="$1" '$0 ~ /^[[:space:]]*#/ || $2 != mp' /etc/fstab > /etc/fstab.rootcamp && mv /etc/fstab.rootcamp /etc/fstab
}

# Au démarrage, un service rattache les disques virtuels, comme si de vrais
# disques étaient branchés (l'ordre, donc le numéro loopN, peut changer !).
_disques_service() {
  local unit=/etc/systemd/system/rootcamp-disques.service
  [[ -f $unit ]] && return 0
  cat > "$unit" <<'UNIT'
[Unit]
Description=rootcamp : branche les disques virtuels des labs
DefaultDependencies=no
After=systemd-udevd.service
Before=local-fs-pre.target
Wants=local-fs-pre.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/sh -c 'for f in /var/lib/rootcamp/disques/*.img; do [ -e "$f" ] && losetup --find --partscan "$f"; done; exit 0'

[Install]
WantedBy=sysinit.target
UNIT
  systemctl daemon-reload
  systemctl enable rootcamp-disques.service &>/dev/null || true
}
