Ticket de l'équipe dev :

    De : Équipe dev
    Objet : 502 Bad Gateway sur l'appli des commandes

    Depuis la maintenance d'hier soir, http://<le serveur>/ affiche
    « 502 Bad Gateway ». Et pendant que tu y es : l'appli a besoin de
    connaître l'adresse IP de chaque client (pour la détection de
    fraude), mais elle voit toujours « inconnu ».

  L'application tourne derrière nginx, qui joue le rôle de
  « reverse proxy » : il reçoit les requêtes sur le port 80 et les
  relaie à l'application (service systemd « appli-commandes »).

OBJECTIF

  - http://localhost/ affiche l'application des commandes, via nginx
  - l'application reçoit l'adresse du client dans l'en-tête HTTP
    X-Forwarded-For
  - l'application tourne et redémarrera avec le serveur

POUR TESTER

    curl -i http://localhost/
