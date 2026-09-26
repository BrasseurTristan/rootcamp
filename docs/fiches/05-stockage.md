# 05 · Stockage

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait les labs du module, avec tes
    propres mots. Les questions ci-dessous servent de fil conducteur :
    remplace-les par tes explications au fur et à mesure.

## Disques, partitions, systèmes de fichiers

- Quelle différence entre un disque, une partition et un système de
  fichiers ?
- Que montrent `lsblk`, `lsblk -f` et `blkid` ?
- MBR ou GPT : quelle différence ? Quand GPT est-il obligatoire ?
- Qu'est-ce que « monter » un système de fichiers ?

## /etc/fstab

- Que signifient les six colonnes d'une ligne de `/etc/fstab` ?
- Pourquoi désigner un disque par son UUID plutôt que par `/dev/sdb1` ?
- Que fait l'option `nofail` ? Que se passe-t-il au démarrage sans elle, si
  le disque manque ?
- Comment vérifier sa configuration avant de redémarrer ?

## L'espace disque

- Quelle différence entre `df` et `du` ? Pourquoi peuvent-ils ne pas être
  d'accord ?
- Pourquoi un fichier supprimé peut-il continuer d'occuper de la place ?
  Comment le trouver ?
- Qu'est-ce qu'un inode ? Que montre `df -i` ?

## LVM

- Que sont un PV, un VG et un LV ?
- Comment agrandir un volume logique ? Pourquoi faut-il aussi agrandir le
  système de fichiers ?
- Pourquoi rétrécir est-il plus risqué qu'agrandir ?

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `stockage-01` | intermédiaire | Le disque plein (`df`, `du`, fichier supprimé mais ouvert) |
| `stockage-02` | intermédiaire | Le nouveau disque (partition, ext4, fstab, UUID, `nofail`) |
| `stockage-03` | avancé | La base de données à l'étroit (LVM, `lvextend -r`) |
