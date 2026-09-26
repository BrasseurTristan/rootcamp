Que s'est-il passé cette nuit ?

    systemctl status rapports
    journalctl -u rapports

Où se trouve le fichier d'unité ? Lis-le avec :

    systemctl cat rapports
---
La directive qui demande à systemd de relancer un service qui plante
s'appelle Restart= (voir « man systemd.service »). Les valeurs
courantes : no (défaut), on-failure, always.

Pour modifier une unité sans toucher au fichier d'origine, systemd
permet d'ajouter des fichiers de SURCHARGE (drop-in) : ils ne
contiennent que les lignes à ajouter ou à changer.
---
    sudo systemctl edit rapports

ouvre un fichier de surcharge vide. Écris-y :

    [Service]
    Restart=on-failure
    RestartSec=5

Enregistre, puis démarre le service. « systemctl cat rapports »
affiche maintenant les deux fichiers.
