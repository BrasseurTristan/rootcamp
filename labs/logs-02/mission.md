Alerte de la supervision :

    [ATTENTION] srv-compta-01 : /var/log/facturation-app/app.log : 100 Mo

  L'application de facturation écrit son journal dans
  /var/log/facturation-app/app.log. Une configuration logrotate a bien
  été prévue pour l'archiver chaque nuit... mais le fichier ne fait
  que grossir.

OBJECTIF

  - la configuration /etc/logrotate.d/facturation-app est valide
  - le log est archivé chaque jour, on garde 7 archives compressées
  - après une rotation, l'application continue d'écrire normalement
    dans le nouveau app.log (sans qu'on ait à la redémarrer à la main)
  - le gros log actuel est archivé (et compressé)

POUR TESTER

    sudo logrotate -d /etc/logrotate.d/facturation-app    simulation
    sudo logrotate -f /etc/logrotate.d/facturation-app    rotation forcée
    ls -lh /var/log/facturation-app/
