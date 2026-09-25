Observe l'organisation LVM, de bas en haut :

    lsblk
    sudo pvs      les volumes physiques (les disques donnés à LVM)
    sudo vgs      les groupes de volumes (la réserve d'espace)
    sudo lvs      les volumes logiques (ce qu'on formate et monte)

Combien d'espace libre reste-t-il dans vg_donnees (colonne VFree) ?
---
Pour agrandir le volume, il faut d'abord agrandir la réserve :

  1. préparer le nouveau disque pour LVM          (pvcreate)
  2. l'ajouter au groupe de volumes vg_donnees    (vgextend)
  3. agrandir le volume logique                   (lvextend)
  4. agrandir le système de fichiers              (resize2fs)

Les étapes 3 et 4 peuvent se faire en une fois.
---
Les commandes :

    sudo pvcreate /dev/<nouveau disque>
    sudo vgextend vg_donnees /dev/<nouveau disque>
    sudo lvextend -r -l +100%FREE vg_donnees/postgres

L'option -r de lvextend agrandit aussi le système de fichiers. Sans
elle, il faut lancer « sudo resize2fs /dev/vg_donnees/postgres ».
Tout ça se fait à chaud, /srv/bdd reste monté.
