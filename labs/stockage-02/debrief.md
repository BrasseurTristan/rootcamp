CE QU'IL FALLAIT FAIRE

    lsblk                                   # repérer le disque vierge
    sudo fdisk /dev/loopN                   # n, Entrée…, w
    sudo mkfs.ext4 /dev/loopNp1
    sudo blkid /dev/loopNp1                 # noter l'UUID

  puis dans /etc/fstab :

    UUID=…  /srv/archives  ext4  defaults,nofail  0  2

  et :

    sudo findmnt --verify && sudo systemctl daemon-reload && sudo mount -a

POURQUOI ÇA MARCHE

  Un disque est découpé en PARTITIONS (la table de partitions, GPT ou
  MBR, est au début du disque). Chaque partition reçoit un SYSTÈME DE
  FICHIERS (ext4, xfs...) qui organise les fichiers. Puis on le MONTE :
  on l'accroche à un dossier de l'arborescence unique de Linux.

  /etc/fstab liste ce qu'il faut monter au démarrage :
    1. quoi       UUID=... (identifiant unique du système de fichiers)
    2. où         /srv/archives
    3. type       ext4
    4. options    defaults,nofail
    5. dump       0 (obsolète)
    6. fsck       2 = vérifier au démarrage, après la racine (1)

  Les noms comme /dev/sdb ou /dev/loop0 dépendent de l'ordre de
  détection des disques : ils peuvent changer d'un démarrage à l'autre.
  L'UUID, lui, est écrit DANS le système de fichiers.

  Sans « nofail », un disque absent au démarrage bloque le serveur en
  mode de secours... et il faut aller sur la console pour le réparer.

À RETENIR

  - lsblk, blkid, df -h, findmnt : voir les disques et les montages.
  - Partition → système de fichiers → montage, toujours dans cet ordre.
  - Dans fstab : UUID (ou LABEL), jamais /dev/sdX.
  - Toujours « findmnt --verify » et « mount -a » après avoir modifié
    fstab, AVANT de redémarrer.
  - Sur des disques de plus de 2 To, GPT est obligatoire (fdisk sait
    créer une table GPT avec la commande g).
