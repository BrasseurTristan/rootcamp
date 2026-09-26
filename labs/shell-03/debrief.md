CE QUI ÉTAIT CASSÉ

  Quatre problèmes, cachés les uns derrière les autres :

  1. Le script n'était pas exécutable (droits 644).
  2. Il était appelé sans chemin. Dans ton terminal, /usr/local/bin
     est dans le PATH, mais cron utilise un PATH minimal
     (/usr/bin:/bin) : « commande introuvable ».
  3. « 2>&1 > log » : les erreurs partaient vers l'ancienne sortie
     standard, pas vers le log. Cron les envoie par mail à root... et
     sans serveur mail, elles disparaissent.
  4. « > » écrasait le log à chaque exécution.

UNE SOLUTION

    sudo chmod +x /usr/local/bin/sauvegarde-compta

  et dans /etc/cron.d/sauvegarde-compta :

    30 2 * * * root /usr/local/bin/sauvegarde-compta >> /var/log/sauvegarde-compta.log 2>&1

POURQUOI ÇA MARCHE

  Chaque processus a des « descripteurs de fichiers » numérotés :
  0 = entrée standard, 1 = sortie standard, 2 = sortie d'erreur.
  « > fichier » (ou « 1> ») redirige le 1, « 2> fichier » le 2, et
  « 2>&1 » veut dire « le 2 va là où va le 1 en ce moment ».
  L'ordre compte : on redirige d'abord le 1, puis on y colle le 2.

  cron ne lit pas ton .bashrc : ni tes alias, ni ton PATH, ni tes
  variables. C'est LA cause numéro un des « ça marche quand je le
  lance à la main, mais pas dans cron ».

À RETENIR

  - Dans cron (et dans les services), utilise des chemins complets.
  - « >> log 2>&1 » : tout dans le log, en ajout. À connaître par cœur.
  - « commande 2>/dev/null » jette les erreurs, « &> fichier » est un
    raccourci bash pour « > fichier 2>&1 » (mais cron utilise sh, pas
    bash : évite-le dans les crontabs).
  - Pour vérifier qu'une tâche cron a tourné : journalctl -u cron
  - Le log va grossir sans fin : c'est le rôle de logrotate, qu'on
    verra dans le module 08.
