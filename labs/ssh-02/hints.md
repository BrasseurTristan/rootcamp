Quels réglages le serveur applique-t-il VRAIMENT ? sshd sait le dire :

    sudo sshd -T -f /etc/rootcamp/ssh/srv-web/sshd_config | grep -Ei 'password|rootlogin'

Compare avec ce que tu lis dans les fichiers de configuration.
---
Un piège de sshd : pour chaque réglage, c'est la PREMIÈRE valeur lue
qui gagne (l'inverse de la plupart des logiciels !). Et la ligne
« Include » en haut de sshd_config fait lire sshd_config.d/ en premier.

    ls /etc/rootcamp/ssh/srv-web/sshd_config.d/
    cat /etc/rootcamp/ssh/srv-web/sshd_config.d/*

Ajouter une ligne à la fin de sshd_config ne sert donc à rien si un
fichier inclus a déjà fixé la valeur.
---
Corrige (ou supprime) le vieux fichier de sshd_config.d/, avec :

    PasswordAuthentication no
    PermitRootLogin no

Puis, TOUJOURS dans cet ordre :

    sudo sshd -t -f /etc/rootcamp/ssh/srv-web/sshd_config   vérifier
    sudo systemctl restart ssh-srv-web                      appliquer

et teste avec ta clé AVANT de fermer ta session actuelle.
