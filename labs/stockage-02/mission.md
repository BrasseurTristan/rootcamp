Un message de l'équipe compta :

    De : Alice (compta)
    Objet : Place pour les archives

    Bonjour,
    On nous a dit qu'un disque avait été ajouté au serveur pour nos
    archives. Il faudrait qu'on puisse l'utiliser dans /srv/archives.

  Un disque neuf et VIERGE de 1 Go a bien été branché sur le serveur.
  À toi de le trouver et de le préparer.

OBJECTIF

  - le disque contient une partition qui occupe tout l'espace
  - cette partition est formatée en ext4
  - elle est montée sur /srv/archives, et le sera encore après un
    redémarrage (déclarée dans /etc/fstab)
  - dans /etc/fstab, la partition est désignée par son UUID
  - le serveur doit démarrer même si ce disque tombe en panne ou
    est débranché

ATTENTION

  Ne touche pas aux autres disques du serveur ! Et une erreur dans
  /etc/fstab peut empêcher le serveur de démarrer : vérifie toujours
  ta configuration avec « sudo findmnt --verify » et « sudo mount -a ».
