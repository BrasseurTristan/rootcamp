Vérifie d'abord le chemin réseau, puis le service :

    ip addr                                          les adresses du serveur
    sudo ip netns exec poste-alice ping -c 2 10.10.0.1
    curl http://127.0.0.1:8080                        depuis le serveur

Le réseau fonctionne, le service aussi... mais seulement en local ?
---
Un programme réseau « écoute » sur une adresse IP et un port. Pour voir
qui écoute où :

    sudo ss -tlnp

  127.0.0.1:8080  n'accepte que les connexions venant du serveur lui-même
  0.0.0.0:8080    accepte les connexions sur toutes les adresses du serveur

Où le service intranet prend-il son adresse d'écoute ?

    systemctl cat intranet
---
L'adresse d'écoute est dans /etc/intranet.conf (variable ADRESSE).
Mets 0.0.0.0 (toutes les adresses) ou 10.10.0.1 (seulement celle du
réseau d'Alice), puis :

    sudo systemctl restart intranet
    sudo ss -tlnp
