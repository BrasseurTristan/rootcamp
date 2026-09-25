#!/usr/bin/env bash
# Monté à la main : tout disparaît au prochain redémarrage.
set -euo pipefail
disk=$(losetup -j /var/lib/rootcamp/disques/archives.img -O NAME -n)
echo ',,L' | sfdisk -q "$disk"
partx -u "$disk" 2>/dev/null || true
mkfs.ext4 -q "${disk}p1"
mount "${disk}p1" /srv/archives
