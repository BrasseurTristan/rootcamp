Suis le chemin d'un paquet, étape par étape :

    sudo ip netns exec poste-alice ip route     par où Alice envoie-t-elle ?
    sudo ip netns exec poste-alice ping -c 2 10.10.0.1
    sudo ip netns exec poste-alice ping -c 2 10.20.0.1
    sudo ip netns exec poste-alice ping -c 2 10.20.0.2

Où est-ce que ça coince ?
---
Par défaut, Linux ne fait PAS passer les paquets d'une carte réseau à
l'autre : il faut activer le routage (« forwarding ») :

    sysctl net.ipv4.ip_forward

Et une connexion, c'est un aller ET un retour. Le serveur de base
sait-il par où renvoyer ses réponses vers 10.10.0.2 ?

    sudo ip netns exec srv-bdd ip route

Pour voir passer les paquets : sudo tcpdump -ni any icmp
---
Les commandes utiles :

    sudo sysctl -w net.ipv4.ip_forward=1       activer tout de suite
    echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/90-routage.conf
                                               ...et au démarrage
    sudo ip netns exec srv-bdd ip route add default via 10.20.0.1
                                               la route de retour
