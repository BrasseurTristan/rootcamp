CE QUI ÉTAIT CASSÉ

  /etc/facturation/facturation.conf avait été supprimé. Des copies
  traînaient un peu partout :

    /srv/sauvegardes/2025-04/...   sauvegarde de prod, version 1
    /srv/sauvegardes/2025-05/...   sauvegarde de prod, version 2
    /srv/sauvegardes/2025-06/...   sauvegarde de prod, version 3  ← la bonne
    /home/alice/facturation.conf   copie perso d'Alice (base de test)
    /var/tmp/essais-facturation/   environnement de test
    /tmp/facturation.conf.swp      fichier temporaire d'un éditeur

UNE SOLUTION

    sudo find / -name 'facturation*' 2>/dev/null
    sudo mkdir -p /etc/facturation
    sudo cp /srv/sauvegardes/2025-06/etc/facturation/facturation.conf \
            /etc/facturation/facturation.conf

POURQUOI ÇA MARCHE

  Sous Linux, chaque dossier racine a un rôle précis (c'est le FHS,
  Filesystem Hierarchy Standard) :

    /etc    la configuration du système et des applications
    /home   les dossiers des utilisateurs
    /srv    les données servies par la machine (sites, partages...)
    /var    les données qui changent : logs, caches, files d'attente
    /tmp    les fichiers temporaires (souvent vidé au redémarrage)
    /usr    les programmes installés, en lecture seule en temps normal

  Savoir ça, c'est savoir où chercher : une config est dans /etc, un
  log dans /var/log, et un fichier dans /tmp ou /home n'est jamais une
  source fiable pour la production.

À RETENIR

  - find cherche par nom, date, taille, propriétaire... :
      find / -name '*.conf' -mtime -7    (modifiés il y a moins de 7 jours)
  - « 2>/dev/null » jette les messages d'erreur (le canal 2) : on en
    reparle dans le lab suivant.
  - « sudo cp » crée une copie qui appartient à root, alors que
    « cp » sans sudo garde ton utilisateur comme propriétaire.
  - Avant d'écraser une config, garde toujours une copie :
      sudo cp fichier.conf fichier.conf.bak
