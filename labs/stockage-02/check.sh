#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/disques.sh
source "$RC_LIB/disques.sh"

mp=/srv/archives
disk=$(disque_dev archives)
[[ -n $disk ]] || rc_die "Le nouveau disque n'est plus branché ! Relance le lab avec 'rootcamp reset'."

# 1. L'entrée de /etc/fstab
line=$(awk -v mp="$mp" '$0 !~ /^[[:space:]]*#/ && $2 == mp' /etc/fstab | tail -n1)
read -r src _ fstype opts _ <<<"$line"
if [[ -n $line ]]; then ok "$mp est déclaré dans /etc/fstab"; else ko "$mp est déclaré dans /etc/fstab"; fi
if [[ $src == UUID=* ]]; then
  ok "le disque est désigné par son UUID dans /etc/fstab"
else
  ko "le disque est désigné par son UUID dans /etc/fstab (pas par /dev/..., qui peut changer)"
fi
if [[ ,$opts, == *,nofail,* ]]; then
  ok "le serveur démarrera même si ce disque est absent (option nofail)"
else
  ko "le serveur démarrera même si ce disque est absent"
fi

# 2. Le montage via fstab fonctionne vraiment
umount "$mp" 2>/dev/null || true
systemctl daemon-reload
if mount "$mp" 2>/dev/null; then
  ok "« mount $mp » fonctionne avec la configuration de /etc/fstab"
else
  ko "« mount $mp » fonctionne avec la configuration de /etc/fstab"
fi

# 3. Ce qui est monté
source_dev=$(findmnt -rn -o SOURCE --target "$mp" 2>/dev/null | head -n1)
parent=$(lsblk -no PKNAME "$source_dev" 2>/dev/null | head -n1)
if mountpoint -q "$mp" && [[ /dev/$parent == "$disk" ]]; then
  ok "$mp est une partition du nouveau disque"
else
  ko "$mp est une partition du nouveau disque"
fi
if [[ $(findmnt -rn -o FSTYPE "$mp" 2>/dev/null) == ext4 && $fstype == ext4 ]]; then
  ok "le système de fichiers est en ext4"
else
  ko "le système de fichiers est en ext4"
fi
size_mb=$(( $(lsblk -bno SIZE "$source_dev" 2>/dev/null || echo 0) / 1024 / 1024 ))
if (( size_mb >= 900 )); then
  ok "la partition utilise tout le disque (${size_mb} Mo)"
else
  ko "la partition utilise tout le disque (${size_mb} Mo)"
fi

rc_result
