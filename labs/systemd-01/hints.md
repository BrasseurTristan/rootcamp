Le premier réflexe face à un service en panne :

    systemctl status facturation-api
    journalctl -u facturation-api

Lis bien les lignes en rouge et le code d'erreur (status=...).
Où se trouve le fichier d'unité ? La première ligne de « status »
te le dit (« Loaded: ... »).
---
Deux erreurs dans l'unité :

  - status=203/EXEC : systemd n'arrive pas à exécuter le programme
    indiqué par ExecStart. Existe-t-il vraiment à cet endroit ?
        ls /usr/local/bin/
  - status=217/USER : l'utilisateur indiqué par User= n'existe pas.
        getent passwd facturation

Après chaque modification du fichier d'unité, systemd doit le relire.
---
Les commandes utiles :

    sudo systemctl edit --full facturation-api   modifier l'unité
    sudo systemctl daemon-reload                 relire les unités (si tu
                                                 as modifié le fichier à la main)
    sudo systemctl restart facturation-api       redémarrer
    sudo systemctl enable facturation-api        activer au démarrage
    sudo systemctl enable --now ...              activer ET démarrer
