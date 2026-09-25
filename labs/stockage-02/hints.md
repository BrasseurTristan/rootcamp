Commence par repérer le nouveau disque :

    lsblk
    lsblk -f        (avec les systèmes de fichiers)

Le nouveau disque est celui de 1 Go, sans partition ni système de
fichiers. Note son nom (par exemple /dev/loop0).
---
Trois étapes :

  1. partitionner : sudo fdisk /dev/<disque>
       n (nouvelle partition), puis Entrée pour garder les valeurs par
       défaut (tout le disque), puis w (écrire et quitter)
  2. formater la partition (le « p1 » à la fin du nom) :
       sudo mkfs.ext4 /dev/<disque>p1
  3. trouver son UUID :
       sudo blkid /dev/<disque>p1
---
La ligne à ajouter à /etc/fstab :

    UUID=<l'uuid>  /srv/archives  ext4  defaults,nofail  0  2

Puis vérifie AVANT de redémarrer quoi que ce soit :

    sudo findmnt --verify
    sudo systemctl daemon-reload
    sudo mount -a
    df -h /srv/archives
