CE QUI ÉTAIT CASSÉ

  1. net.ipv4.ip_forward = 0 : le serveur recevait les paquets d'Alice
     destinés à 10.20.0.2... et les jetait, car ils ne lui étaient pas
     adressés.
  2. srv-bdd n'avait pas de route par défaut : même une fois les
     paquets arrivés, il ne savait pas où renvoyer ses réponses vers
     10.10.0.2 (réseau qu'il ne connaît pas).

UNE SOLUTION

    sudo sysctl -w net.ipv4.ip_forward=1
    echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/90-routage.conf
    sudo ip netns exec srv-bdd ip route add default via 10.20.0.1

POURQUOI ÇA MARCHE

  Chaque machine décide où envoyer un paquet grâce à sa TABLE DE
  ROUTAGE (ip route) : « pour tel réseau, passe par telle passerelle ».
  La route « default » sert pour tout le reste.

  Un routeur est simplement une machine avec plusieurs réseaux qui
  accepte de faire passer les paquets de l'un à l'autre : c'est
  ip_forward. Et comme TCP a besoin de réponses, les DEUX extrémités
  doivent savoir joindre l'autre. L'oubli de la route de retour est un
  classique : « le ping part, mais ne revient pas ».

À RETENIR

  - ip addr (mes adresses), ip route (ma table de routage),
    ip route get <ip> (quel chemin pour cette destination ?).
  - Diagnostiquer de proche en proche : sa passerelle, puis l'autre
    côté du routeur, puis la cible.
  - tcpdump montre les paquets qui passent vraiment : on voit tout de
    suite si c'est l'aller ou le retour qui manque.
  - sysctl -w change un réglage du noyau jusqu'au prochain démarrage ;
    un fichier dans /etc/sysctl.d/ le rend permanent.
