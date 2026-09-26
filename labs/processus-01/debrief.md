CE QUI ÉTAIT CASSÉ

  Trois étages :

    crontab de bob :  @reboot /opt/outils/surveillant
                           └─ /opt/outils/surveillant    (relance l'indexeur
                                   │                      toutes les 2 s)
                                   └─ /opt/outils/indexeur   (boucle infinie :
                                                              100 % CPU)

  Tuer l'indexeur ne servait à rien : son parent le relançait. Tuer le
  parent réglait le problème jusqu'au prochain redémarrage.

UNE SOLUTION

    ps -ef --forest | grep -B2 indexeur    # trouver le parent
    sudo pkill -f /opt/outils/surveillant   # le parent d'abord
    sudo pkill -f /opt/outils/indexeur      # puis l'enfant
    sudo crontab -e -u bob                  # supprimer la ligne @reboot

POURQUOI ÇA MARCHE

  Tout processus a un parent (PPID). Quand un parent meurt, ses enfants
  sont « adoptés » par systemd (PID 1) et continuent de tourner : c'est
  pour ça qu'il fallait tuer les deux.

  kill envoie un SIGNAL à un processus :
    TERM (15, par défaut)  « arrête-toi proprement, s'il te plaît »
    KILL (9)               arrêt immédiat par le noyau, sans négociation
    HUP (1)                souvent : « relis ta configuration »
  On essaie toujours TERM avant KILL : le programme peut ainsi fermer
  ses fichiers proprement.

À RETENIR

  - top / htop / ps aux --sort=-%cpu : qui consomme quoi.
  - Un processus qui « revient » a un parent qui le relance : remonte
    l'arbre (ps -ef --forest, pstree).
  - Après avoir éteint l'incendie, cherche ce qui le rallumera au
    démarrage : crontabs (crontab -l -u ...), services systemd
    (systemctl list-unit-files --state=enabled), /etc/cron.d/...
  - La bonne suite : prévenir bob, et s'il a besoin de son indexeur,
    en faire un vrai service systemd avec des limites (CPUQuota=).
