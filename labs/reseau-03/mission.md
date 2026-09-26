Le serveur a deux pattes :

    poste d'Alice ──── 10.10.0.1 [ CE SERVEUR ] 10.20.0.1 ──── srv-bdd
     10.10.0.2           réseau des postes    réseau des serveurs   10.20.0.2

  Il doit servir de ROUTEUR entre le réseau des postes et le réseau des
  serveurs. Nouveau ticket :

    De : Alice (compta)
    Objet : Mon outil de reporting n'accède pas à la base

    Mon outil doit se connecter à la base de données, 10.20.0.2 port
    5432, mais ça ne passe pas.

  Tu as la main sur ce serveur ET sur srv-bdd :

    sudo ip netns exec poste-alice <commande>   sur le poste d'Alice
    sudo ip netns exec srv-bdd <commande>       sur le serveur de base

OBJECTIF

  - depuis le poste d'Alice, la base 10.20.0.2:5432 répond
  - le routage du serveur reste actif après un redémarrage

POUR TESTER

    sudo ip netns exec poste-alice nc -zv 10.20.0.2 5432
