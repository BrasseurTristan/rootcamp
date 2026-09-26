CE QUI ÉTAIT CASSÉ

  /etc/hosts contenait une vieille ligne, ajoutée à la main pendant un
  dépannage il y a longtemps :

    10.20.0.99      db.interne

  Comme /etc/hosts passe avant le DNS, ce serveur-là continuait d'aller
  vers l'ancienne adresse, alors que tous les autres suivaient le DNS.

UNE SOLUTION

    getent hosts db.interne             # → 10.20.0.99 : pas la bonne
    grep hosts /etc/nsswitch.conf       # → files avant dns
    sudo sed -i 's/^10\.20\.0\.99 .*db\.interne.*/10.20.0.2 db.interne/' /etc/hosts
    test-bdd

  (Dans la vraie vie, on supprimerait la ligne pour laisser le DNS
  répondre. Ici, il n'y a pas de serveur DNS, donc on la corrige.)

POURQUOI ÇA MARCHE

  Les programmes demandent « quelle est l'adresse de db.interne ? » à
  la bibliothèque système (la glibc), qui suit /etc/nsswitch.conf :

    hosts: files dns    → 1. /etc/hosts   2. le DNS (/etc/resolv.conf)

  La première source qui répond gagne.

À RETENIR

  - getent hosts <nom> : ce que les PROGRAMMES obtiennent vraiment
    (en suivant nsswitch.conf).
  - dig / nslookup / host : interrogent le DNS DIRECTEMENT, sans lire
    /etc/hosts. Si dig et getent ne sont pas d'accord, regarde
    /etc/hosts !
  - /etc/hosts est pratique pour un test, mais une entrée oubliée
    devient une bombe à retardement. Documente-la, puis supprime-la.
  - Ne mets pas d'adresses IP en dur dans les configurations : un nom
    permet de migrer un service sans toucher aux applications.
