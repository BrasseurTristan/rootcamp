Le dossier partagé de la compta fonctionne… presque. Nouveau ticket :

    De : Bob (compta)
    Objet : Je ne peux pas modifier les fichiers d'Alice

    Salut,
    Quand Alice crée un fichier dans /srv/compta, je peux le lire mais
    pas le modifier. Pareil dans l'autre sens : elle ne peut rien
    ajouter dans le dossier factures/ que j'ai créé.
    On ne va pas t'appeler à chaque fois qu'on crée un fichier...

OBJECTIF

  - les fichiers et dossiers existants (relances.txt, factures/)
    sont modifiables par toute l'équipe compta
  - tout NOUVEAU fichier ou dossier créé par alice ou bob dans
    /srv/compta appartient automatiquement au groupe compta et est
    modifiable par l'équipe, sans que personne n'ait rien à faire
  - ça doit marcher même avec l'umask par défaut (022) : impossible
    de garantir que chaque programme utilisera un autre umask
  - le dossier reste fermé aux autres (mallory comprise)

POUR TESTER

    sudo -u alice sh -c 'echo test > /srv/compta/essai.txt'
    ls -l /srv/compta
    sudo -u bob sh -c 'echo modif >> /srv/compta/essai.txt'
