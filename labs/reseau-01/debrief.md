CE QUI ÉTAIT CASSÉ

  /etc/intranet.conf contenait ADRESSE=127.0.0.1 : l'intranet
  n'écoutait que sur l'interface « loopback », qui n'est joignable
  que depuis le serveur lui-même. Le poste d'Alice recevait un refus
  de connexion (RST) : rien n'écoutait sur 10.10.0.1:8080.

UNE SOLUTION

    sudo sed -i 's/^ADRESSE=.*/ADRESSE=0.0.0.0/' /etc/intranet.conf
    sudo systemctl restart intranet
    sudo ss -tlnp | grep 8080

POURQUOI ÇA MARCHE

  Une connexion TCP arrive sur une adresse IP ET un port. Le noyau la
  confie au programme qui écoute sur cette combinaison :

    127.0.0.1   la boucle locale : jamais joignable de l'extérieur
    10.10.0.1   une adresse précise du serveur
    0.0.0.0     toutes les adresses IPv4 du serveur ([::] en IPv6)

  « Ça marche sur le serveur » ne prouve donc rien : teste toujours
  depuis là où sont les utilisateurs.

À RETENIR

  - ss -tlnp : qui écoute (-l) en TCP (-t), avec les numéros (-n) et
    le programme (-p). LA commande du diagnostic réseau.
  - « Connection refused » : rien n'écoute (ou un pare-feu rejette).
    « Timeout » : les paquets se perdent (route, pare-feu qui jette).
  - Méthode : de bas en haut. L'adresse (ip addr), le chemin (ping),
    le port (ss, curl), puis l'application.
  - Écouter sur 0.0.0.0 expose le service à tous les réseaux du
    serveur : c'est au pare-feu de filtrer (lab reseau-04).
