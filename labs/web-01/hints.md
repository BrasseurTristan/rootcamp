nginx explique toujours pourquoi il refuse une page, dans son journal
d'erreurs. Où est-il ? Regarde la configuration du site :

    cat /etc/nginx/sites-enabled/compta
    sudo tail /var/log/nginx/compta.error.log

nginx tourne avec quel utilisateur ?

    ps -o user,cmd -C nginx
---
Premier problème : l'utilisateur de nginx (www-data) doit pouvoir
traverser tous les dossiers du chemin (droit x, vu dans le module 02)
et lire les fichiers. Plutôt que d'ouvrir le dossier d'alice, range le
site au bon endroit :

    sudo mkdir -p /var/www/compta
    sudo cp -r /home/alice/site-compta/. /var/www/compta/

et change la directive « root » du site.
---
Deuxième problème, visible dans le journal une fois le premier réglé :
« directory index of ... is forbidden ». nginx cherche un fichier
d'accueil nommé selon la directive « index »... Renomme la page ou
adapte la directive. Puis :

    sudo nginx -t
    sudo systemctl reload nginx
