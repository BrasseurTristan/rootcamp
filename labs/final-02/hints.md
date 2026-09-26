Pas de panique, de la MÉTHODE. Remonte le chemin d'une requête, de
l'utilisateur jusqu'aux données, et vérifie chaque étape :

  1. le nom           getent hosts carnet.interne
  2. le pare-feu      sudo nft list ruleset
  3. nginx            systemctl status nginx ; sudo nginx -t
  4. l'application    systemctl status carnet ; curl http://127.0.0.1:5000
  5. les données      ls -ld /var/lib/carnet

Et à chaque fois : que disent les journaux ?
---
Les journaux à regarder :

    journalctl -u nginx -p err -n 20
    journalctl -u carnet -n 20
    sudo tail /var/log/nginx/error.log

Un « 502 » vient de nginx qui n'arrive pas à joindre l'application.
Un « 500 » vient de l'application elle-même.
Un « timeout » depuis le poste d'Alice fait penser au pare-feu.
---
Les six pannes possibles (trois sont actives) :

  - une entrée de /etc/hosts
  - une règle du pare-feu (/etc/nftables.conf)
  - un chemin de clé dans la configuration nginx
  - un port dans la configuration nginx
  - un chemin de programme dans l'unité systemd
  - le propriétaire du dossier de données

Compare avec ce que tu as construit dans final-01.
