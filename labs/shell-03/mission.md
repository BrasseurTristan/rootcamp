Un message inquiet de la compta :

    De : Alice (compta)
    Objet : La sauvegarde tourne vraiment ?

    Bonjour,
    On devait avoir une sauvegarde de /srv/compta chaque nuit, dans
    /var/backups. Je ne vois jamais rien, et le fichier de log
    /var/log/sauvegarde-compta.log n'existe même pas.
    Tu peux vérifier ?

  La sauvegarde est lancée chaque nuit à 2 h 30 par cron, avec le
  fichier /etc/cron.d/sauvegarde-compta.

OBJECTIF

  - la tâche doit fonctionner quand CRON la lance (pas seulement quand
    tu la lances toi-même dans ton terminal)
  - toute la sortie du script, messages normaux ET messages d'erreur,
    doit aller dans /var/log/sauvegarde-compta.log
  - chaque nuit s'ajoute au log, sans effacer les nuits précédentes
  - la sauvegarde reste planifiée à 2 h 30, en root

POUR TESTER COMME CRON

  Pas besoin d'attendre 2 h 30. Cron lance la commande avec /bin/sh
  et un environnement presque vide. Pour faire pareil :

    sudo env -i PATH=/usr/bin:/bin /bin/sh -c 'LA COMMANDE DU FICHIER CRON'
