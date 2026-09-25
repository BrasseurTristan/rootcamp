Le serveur a planté cette nuit et a redémarré tout seul.

    De : Responsable infra
    Objet : Que s'est-il passé cette nuit ?

    J'ai voulu regarder les logs d'avant le plantage avec
    « journalctl -b -1 »... et il n'y a RIEN. Comment on enquête, du
    coup ? Fais en sorte que ça n'arrive plus.

  (Pas besoin de redémarrer la VM pour ce lab.)

OBJECTIF

  - le journal systemd est conservé sur le disque, donc après un
    redémarrage
  - sa taille sur le disque est limitée (1 Go maximum), pour ne pas
    remplir le disque
  - le changement est appliqué : le journal s'écrit déjà sur le disque

POUR TESTER

    journalctl --list-boots
    journalctl --disk-usage
    ls /var/log/journal/
