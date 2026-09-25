Un message de l'équipe dev :

    De : Équipe dev
    Objet : Accès à l'admin de la base

    Il nous faut le jeton de session affiché par l'interface
    d'administration de la base de données, sur srv-bdd (10.20.0.2).
    Problème : pour des raisons de sécurité, cette interface n'écoute
    que sur 127.0.0.1:8080 DE srv-bdd. Elle est donc inaccessible par
    le réseau... sauf à passer par SSH.

  Tu as un accès SSH à srv-bdd : compte deploy, clé ~/.ssh/cle_bdd.
  (Interdiction de tricher avec « ip netns exec srv-bdd » : dans la
  vraie vie, srv-bdd serait une autre machine.)

OBJECTIF

  1. Crée un alias « bdd » dans ~/.ssh/config : « ssh bdd » doit te
     connecter à deploy@10.20.0.2 avec la bonne clé, sans autre option.
  2. Ouvre un tunnel SSH : sur CE serveur, http://127.0.0.1:9000 doit
     afficher l'interface d'administration de srv-bdd.
  3. Copie le jeton de session affiché par l'interface dans ~/jeton.txt.

  Laisse le tunnel ouvert pour la vérification.
