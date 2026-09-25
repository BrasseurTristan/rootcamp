CE QUI ÉTAIT CASSÉ

  Sur les 200 Mo de /srv/donnees :

    ~108 Mo  six vieux exports temporaires dans exports/tmp/
     60 Mo   un journal supprimé (rm) mais toujours ouvert par le
             service « exporteur » : invisible pour du, mais bien
             compté par df

UNE SOLUTION

    sudo du -h /srv/donnees | sort -h | tail
    sudo rm /srv/donnees/exports/tmp/*
    sudo lsof +L1                        # le fichier « (deleted) »
    systemctl status <PID>               # → exporteur.service
    sudo systemctl stop exporteur
    df -h /srv/donnees

POURQUOI ÇA MARCHE

  Sous Linux, un nom de fichier n'est qu'un LIEN vers les données
  (l'inode). « rm » supprime le lien ; les données ne sont libérées
  que quand il n'y a plus aucun lien ET plus aucun processus qui a le
  fichier ouvert. D'où l'écart entre du (qui additionne les fichiers
  visibles) et df (qui demande l'état réel au système de fichiers).

  Cas typique en production : on supprime un énorme log sans
  prévenir le service qui l'écrit. Le disque reste plein.

À RETENIR

  - df : l'espace des systèmes de fichiers ; du : la taille des fichiers.
  - « du -h | sort -h | tail » pour trouver ce qui prend de la place.
  - df et du ne sont pas d'accord ? Pense aux fichiers supprimés mais
    ouverts : lsof +L1.
  - Pour vider un log ouvert sans l'effacer : « truncate -s 0 fichier »
    (ou « > fichier »), le processus continue d'écrire au début.
  - Un disque peut aussi être « plein » d'inodes (trop de petits
    fichiers) alors qu'il reste de la place : df -i.
