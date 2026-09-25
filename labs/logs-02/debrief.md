CE QUI ÉTAIT CASSÉ

    rotate sept     → logrotate attend un nombre : « rotate 7 »
    (pas de « } »)  → le bloc n'était pas fermé

  logrotate ignorait donc toute la configuration. Et même corrigée, une
  rotation simple aurait posé problème : l'application garde son log
  ouvert et aurait continué d'écrire dans app.log.1.

UNE SOLUTION

    /var/log/facturation-app/*.log {
        daily
        rotate 7
        compress
        delaycompress
        missingok
        notifempty
        copytruncate
    }

  puis :

    sudo logrotate -d /etc/logrotate.d/facturation-app
    sudo logrotate -f /etc/logrotate.d/facturation-app

POURQUOI ÇA MARCHE

  logrotate est lancé chaque jour (par le timer systemd
  logrotate.timer). Pour chaque fichier, il décide s'il faut tourner :
  app.log devient app.log.1, app.log.1 devient app.log.2.gz, etc.,
  et au-delà de « rotate 7 » les plus vieux sont supprimés.

  Un programme qui a ouvert un fichier le garde par son inode, pas par
  son nom : renommer le fichier ne le dérange pas, il continue d'écrire
  au même endroit. D'où copytruncate (on vide le fichier sur place) ou
  postrotate (on demande au programme de rouvrir son log).

À RETENIR

  - logrotate -d pour vérifier, logrotate -f pour forcer.
  - Directives courantes : daily/weekly, rotate N, compress,
    delaycompress, missingok, notifempty, copytruncate, postrotate.
  - Un log qui n'est plus archivé finit toujours par remplir le disque
    (lab stockage-01 !).
  - journald a sa propre gestion de taille (lab suivant) : logrotate
    concerne les fichiers de log classiques.
