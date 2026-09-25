#!/usr/bin/env bash
# fstab désigne le disque par /dev/loopNp1 : le nom peut changer au prochain démarrage.
set -euo pipefail
disk=$(losetup -j /var/lib/rootcamp/disques/archives.img -O NAME -n)
echo ',,L' | sfdisk -q "$disk"
partx -u "$disk" 2>/dev/null || true
mkfs.ext4 -q "${disk}p1"
echo "${disk}p1 /srv/archives ext4 defaults,nofail 0 2" >> /etc/fstab
systemctl daemon-reload
mount -a
