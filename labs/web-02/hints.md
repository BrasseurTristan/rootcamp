« 502 Bad Gateway » : nginx n'a pas réussi à obtenir une réponse de
l'application qu'il relaie. Le journal d'erreurs dit pourquoi :

    sudo tail /var/log/nginx/appli.error.log

Vers quelle adresse nginx relaie-t-il ? L'application écoute-t-elle
là ?

    grep proxy_pass /etc/nginx/sites-enabled/appli
    sudo ss -tlnp
    systemctl status appli-commandes
---
Deux problèmes pour le 502 : l'application est arrêtée (et pas activée
au démarrage), et nginx ne relaie pas vers le bon port. Une fois
l'application démarrée, « ss -tlnp » te donne son vrai port.

Pour l'adresse du client : vu de l'application, toutes les requêtes
viennent de nginx. C'est à nginx d'ajouter un en-tête qui transmet
l'adresse d'origine.
---
    sudo systemctl enable --now appli-commandes

et dans le bloc « location » du site :

    proxy_pass http://127.0.0.1:8081;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $host;

puis :

    sudo nginx -t && sudo systemctl reload nginx
