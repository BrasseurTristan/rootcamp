CE QUI ÉTAIT CASSÉ

  Le processus a été tué (status=9/KILL dans le journal) et l'unité ne
  contenait pas de directive Restart= : par défaut, systemd ne relance
  pas un service qui s'arrête, même brutalement.

UNE SOLUTION

    sudo systemctl edit rapports

  avec dans le fichier de surcharge :

    [Service]
    Restart=on-failure
    RestartSec=5

  puis :

    sudo systemctl start rapports

POURQUOI ÇA MARCHE

  « systemctl edit » crée /etc/systemd/system/rapports.service.d/override.conf.
  systemd lit d'abord l'unité d'origine, puis applique les fichiers de
  surcharge par-dessus. La mise à jour du paquet remplacera le fichier
  de /usr/lib/systemd/system/, mais ta surcharge dans /etc restera.

  Restart=on-failure : relance si le programme s'arrête avec une
  erreur ou est tué par un signal, mais PAS si c'est toi qui l'arrêtes
  avec « systemctl stop ». RestartSec=5 attend 5 secondes avant de
  relancer, pour ne pas s'emballer.

À RETENIR

  - /usr/lib/systemd/system/ : unités des paquets, on n'y touche pas.
    /etc/systemd/system/ : unités et surcharges de l'admin, prioritaires.
  - « systemctl edit » (surcharge) ou « systemctl edit --full » (copie
    complète dans /etc) : préfère la surcharge, plus lisible.
  - « systemctl cat » montre l'unité ET ses surcharges.
  - Relancer automatiquement masque un problème, il ne le résout pas :
    surveille les redémarrages (journalctl -u) et corrige la cause.
  - Si un service plante trop souvent (5 fois en 10 s par défaut),
    systemd abandonne : voir StartLimitBurst= et StartLimitIntervalSec=.
