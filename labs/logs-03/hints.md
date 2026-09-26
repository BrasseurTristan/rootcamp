Où journald range-t-il le journal ? En mémoire (/run/log/journal),
ou sur le disque (/var/log/journal) ?

    journalctl --disk-usage
    ls /run/log/journal/ /var/log/journal/

Et quelle est sa configuration ? Elle est répartie sur plusieurs
fichiers ; cette commande les affiche tous, dans l'ordre de lecture :

    systemd-analyze cat-config systemd/journald.conf
---
L'option qui décide où va le journal est Storage= (voir « man
journald.conf ») :

    volatile     en mémoire seulement : perdu au redémarrage
    persistent   sur le disque (/var/log/journal)
    auto         sur le disque si /var/log/journal existe

Pour journald (contrairement à sshd !), c'est la DERNIÈRE valeur lue
qui gagne : les fichiers de journald.conf.d/ passent après
journald.conf.
---
Crée (ou corrige) un fichier dans /etc/systemd/journald.conf.d/ :

    [Journal]
    Storage=persistent
    SystemMaxUse=500M

puis applique :

    sudo systemctl restart systemd-journald
    journalctl --disk-usage
