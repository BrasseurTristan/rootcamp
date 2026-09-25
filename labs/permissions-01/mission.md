Tu viens d'arriver dans l'équipe infra. Premier ticket de la journée :

    De : Alice (compta)
    Objet : Impossible d'ouvrir le dossier partagé !

    Bonjour,
    Depuis la migration du serveur, ni Bob ni moi n'arrivons à ouvrir
    /srv/compta. On a la clôture vendredi, c'est urgent...
    Par contre, surtout : Mallory (stagiaire marketing) ne doit PAS
    avoir accès à ces fichiers.
    Merci !

OBJECTIF

  - alice et bob peuvent entrer dans /srv/compta, lire et modifier
    bilan-2025.txt, et créer de nouveaux fichiers
  - mallory n'a aucun accès au dossier
  - les autres utilisateurs du serveur n'ont aucun droit dessus
    (un chmod 777 sera refusé !)

POUR TESTER

  Tu peux agir « dans la peau » d'un utilisateur avec sudo :

    sudo -u alice ls /srv/compta
    sudo -u bob touch /srv/compta/test.txt
