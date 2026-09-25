Alerte de la supervision, suivie d'un appel de la compta :

    [CRITIQUE] srv-compta-01 : /srv/donnees plein à 95 %

    De : Alice (compta)
    Objet : Impossible d'enregistrer quoi que ce soit !
    « Plus d'espace disponible sur le périphérique »...

  Ce que dit la procédure de l'équipe :
    - les fichiers de /srv/donnees/exports/tmp sont des copies
      temporaires : on peut les supprimer
    - TOUT le reste doit être conservé (bilans, export de septembre)

OBJECTIF

  - au moins 80 % de l'espace de /srv/donnees est libre
  - les bilans et l'export de septembre sont intacts
  - plus aucun processus ne garde ouvert un fichier supprimé

POUR TESTER

    df -h /srv/donnees
