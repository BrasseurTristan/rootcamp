Commence par lire l'erreur : quel fichier l'application cherche-t-elle ?

    facturation

Puis cherche toutes les copies de ce fichier sur le serveur :

    sudo find / -name 'facturation*' 2>/dev/null

(le « 2>/dev/null » cache les messages d'erreur « Permission non accordée »)
---
Pour chaque copie trouvée, regarde son contenu et sa date :

    cat <fichier>
    ls -l <fichier>

Les commentaires en haut des fichiers sont bavards. Quelles copies
sont de vraies sauvegardes de production ? Laquelle est la plus récente ?

Chaque dossier a un rôle : /home (fichiers des utilisateurs),
/var/tmp et /tmp (temporaires), /srv (données servies par la machine)...
---
Pour remettre le fichier en place :

    sudo mkdir -p /etc/facturation
    sudo cp <la-bonne-sauvegarde> /etc/facturation/facturation.conf

Vérifie ensuite avec « facturation » et « ls -l /etc/facturation ».
