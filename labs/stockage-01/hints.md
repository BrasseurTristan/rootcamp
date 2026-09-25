Deux commandes à ne pas confondre :

    df -h                  l'espace utilisé et libre de chaque système de fichiers
    sudo du -sh /srv/donnees/*    la taille de chaque dossier

Descends dans les dossiers les plus gros :

    sudo du -h /srv/donnees | sort -h | tail
---
Après avoir supprimé les exports temporaires, compare :

    df -h /srv/donnees         ce que le système de fichiers dit
    sudo du -sh /srv/donnees   la somme des fichiers qu'on voit

Si df annonce beaucoup plus que du, de l'espace est occupé par des
fichiers qu'on ne voit plus... Un fichier supprimé n'est vraiment
libéré que quand plus aucun processus ne l'a ouvert.
---
Pour trouver les fichiers supprimés mais encore ouverts :

    sudo lsof +L1
    sudo lsof /srv/donnees

Tu obtiens le PID du processus. Quel service est-ce ?

    systemctl status <PID>

L'export est terminé depuis longtemps : on peut l'arrêter (ou le
redémarrer) proprement, ce qui libère le fichier.
