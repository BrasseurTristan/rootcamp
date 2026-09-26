Les services écoutent-ils ? Et que dit le pare-feu ?

    sudo ss -tlnp
    sudo nft list ruleset
    cat /etc/nftables.conf

Lis la chaîne « entree » ligne par ligne : pour chaque paquet qui
arrive, nftables applique la PREMIÈRE règle qui correspond. Si aucune
ne correspond, c'est la politique de la chaîne (policy) qui s'applique.
---
La politique est « drop » : tout ce qui n'est pas autorisé est jeté
(c'est bien). Il faut donc :

  - AJOUTER une règle qui autorise le port 8080
  - RETIRER la règle qui autorise le port 3306 depuis le réseau

Le serveur, lui, joint sa base par l'interface « lo », qui reste
autorisée par la règle « iif lo accept ».
---
Modifie /etc/nftables.conf :

    tcp dport 22 accept        # SSH
    tcp dport 8080 accept      # intranet

(et supprime la ligne du port 3306), puis vérifie et applique :

    sudo nft -c -f /etc/nftables.conf     vérifier la syntaxe
    sudo systemctl restart nftables       appliquer
    sudo nft list ruleset
