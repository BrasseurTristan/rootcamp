Ticket urgent du service commercial :

    De : Direction commerciale
    Objet : Plus aucun rapport depuis cette nuit !

    Les rapports de vente ne sont plus générés depuis 3 h du matin.
    Il faut que ça reparte, et que ça ne se reproduise plus.

  Le service « rapports » est fourni par le paquet d'un éditeur. Le
  processus a été tué cette nuit par le noyau (manque de mémoire).
  L'éditeur travaille sur la fuite mémoire ; en attendant, il faut que
  le service se relance tout seul s'il plante.

OBJECTIF

  - si le processus du service plante, systemd le relance
    automatiquement, sans intervention humaine
  - le service est démarré et activé au démarrage
  - le fichier d'unité fourni par le paquet ne doit PAS être modifié :
    il serait écrasé à la prochaine mise à jour du paquet

POUR TESTER

    systemctl status rapports
    sudo kill -9 <PID principal>     # simule un plantage
    systemctl status rapports        # le PID doit avoir changé
