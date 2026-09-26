Lis le fichier cron, puis essaie de lancer la commande comme cron :

    cat /etc/cron.d/sauvegarde-compta
    sudo env -i PATH=/usr/bin:/bin /bin/sh -c 'sauvegarde-compta'

Il y a plusieurs problèmes, corrige-les un par un. Premier indice :
où se trouve le script, et est-ce que ce dossier fait partie du PATH
de cron ? Est-il seulement exécutable ?

    ls -l /usr/local/bin/sauvegarde-compta
---
Chaque programme a deux sorties :

    1 (stdout)  les messages normaux
    2 (stderr)  les messages d'erreur

Les redirections se lisent de GAUCHE À DROITE :

    commande 2>&1 > fichier    2 va là où va 1 MAINTENANT (le terminal),
                               puis 1 part dans le fichier
    commande > fichier 2>&1    1 part dans le fichier, puis 2 va là où
                               va 1 : le fichier

Et « > » écrase, alors que « >> » ajoute à la fin.
---
Les corrections :

  - rendre le script exécutable : chmod +x
  - appeler le script avec son chemin complet (/usr/local/bin/...),
    ou ajouter une ligne PATH=... en haut du fichier cron
  - écrire la redirection dans le bon ordre, en mode ajout :

        >> /var/log/sauvegarde-compta.log 2>&1
