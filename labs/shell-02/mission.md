Un message de l'équipe de développement :

    De : Équipe dev
    Objet : Pics d'erreurs 500 sur l'API de facturation

    Hello,
    Depuis hier, l'API de facturation renvoie beaucoup d'erreurs 500.
    On soupçonne quelques clients qui envoient des requêtes mal formées.
    Tu peux nous dire quelles adresses IP en provoquent le plus ?
    Le journal est dans /var/log/facturation/acces.log.

OBJECTIF

  Écrire dans le fichier ~/rapport-erreurs.txt les 3 adresses IP qui
  ont reçu le plus de réponses avec le code HTTP 500, une par ligne,
  de la plus fréquente à la moins fréquente.

  Le journal fait plusieurs milliers de lignes : pas question de
  compter à la main. Tout se fait en une ligne de commande.

LE FORMAT DU JOURNAL

  Chaque ligne décrit une requête :

    198.51.100.23 - - [25/Sep/2026:14:02:11 +0200] "GET /api/factures HTTP/1.1" 500 3120

  Le premier champ est l'adresse IP du client, l'avant-dernier le code
  HTTP de la réponse, le dernier la taille de la réponse en octets.
