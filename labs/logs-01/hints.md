Commence par l'état du service :

    systemctl status paiements

Les dernières lignes affichées ne disent pas grand-chose... Le vrai
message est plus haut, noyé parmi les centaines de lignes que le
service écrit à chaque démarrage.
---
journalctl sait filtrer :

    journalctl -u paiements              seulement ce service
    journalctl -u paiements -p err       seulement les erreurs (et pire)
    journalctl -u paiements -b           depuis le dernier démarrage
    journalctl -u paiements --since "10 min ago"
    journalctl -u paiements -g ERREUR    chercher un motif
    journalctl -u paiements -f           suivre en direct (Ctrl+C)
---
    journalctl -u paiements -p err -n 5

L'erreur indique le fichier, le paramètre et les valeurs possibles.
Corrige-le puis redémarre :

    sudo nano /etc/paiements/paiements.conf
    sudo systemctl restart paiements
