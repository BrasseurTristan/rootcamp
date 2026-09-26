#!/usr/bin/env bash
# Sans nofail : si le disque manque au démarrage, le serveur reste bloqué.
set -euo pipefail
disk=$(losetup -j /var/lib/rootcamp/disques/archives.img -O NAME -n)
echo ',,L' | sfdisk -q "$disk"
partx -u "$disk" 2>/dev/null || true
mkfs.ext4 -q "${disk}p1"
uuid=$(blkid -p -s UUID -o value "${disk}p1")
echo "UUID=$uuid /srv/archives ext4 defaults 0 2" >> /etc/fstab
systemctl daemon-reload
mount -a
