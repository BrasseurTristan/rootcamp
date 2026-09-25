Alerte de la supervision :

    [CRITIQUE] srv-compta-01 : /srv/bdd plein à 90 %

    De : Équipe dev
    La base de données de facturation va bientôt refuser les
    écritures. Il nous faudrait au moins 800 Mo, et SANS arrêter la
    base ni perdre de données, évidemment.

  /srv/bdd est un volume LVM. Un second disque vierge de 600 Mo a été
  ajouté au serveur pour l'occasion.

OBJECTIF

  - le volume de /srv/bdd fait au moins 800 Mo
  - le système de fichiers de /srv/bdd profite de cette place
  - les données sont intactes et /srv/bdd reste monté
  - le second disque fait partie du groupe de volumes vg_donnees

POUR TESTER

    df -h /srv/bdd
    sudo lvs
