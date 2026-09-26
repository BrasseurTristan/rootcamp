CE QU'IL FALLAIT FAIRE

    lsblk                                        # repérer le disque vierge
    sudo pvcreate /dev/loopN
    sudo vgextend vg_donnees /dev/loopN
    sudo lvextend -r -l +100%FREE vg_donnees/postgres
    df -h /srv/bdd

POURQUOI ÇA MARCHE

  LVM ajoute une couche entre les disques et les systèmes de fichiers :

    PV  volume physique   un disque (ou une partition) confié à LVM
    VG  groupe de volumes  une réserve d'espace, faite d'un ou plusieurs PV
    LV  volume logique     un morceau de la réserve, qu'on formate et monte

  Un LV n'est pas lié à un disque précis : il peut s'étendre sur
  plusieurs PV, grandir (et parfois rétrécir) sans démonter. C'est ce
  qui rend LVM si pratique sur les serveurs.

  Mais agrandir le LV ne suffit pas : le système de fichiers qui est
  dessus garde sa taille tant qu'on ne l'agrandit pas (resize2fs pour
  ext4, xfs_growfs pour xfs). C'est l'oubli le plus courant : lvs
  affiche 900 Mo, df affiche toujours 300 Mo.

À RETENIR

  - pvs / vgs / lvs : l'état des trois couches.
  - Agrandir : pvcreate → vgextend → lvextend -r.
  - « -r » (--resizefs) : lvextend agrandit aussi le système de fichiers.
  - Agrandir un ext4 ou un xfs se fait à chaud. RÉTRÉCIR est risqué :
    impossible avec xfs, démontage obligatoire avec ext4. Sauvegarde !
  - Laisser un peu d'espace libre dans le VG permet aussi de faire des
    instantanés (snapshots) LVM avant une opération délicate.
