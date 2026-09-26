BRAVO : TU AS MIS UNE APPLICATION EN PRODUCTION

  Récapitulons ce que tu as construit, couche par couche :

    poste d'Alice ──► pare-feu (nftables) ──► nginx :443 (TLS)
                         22/80/443 seulement      │ certificat signé par la CA
                                                  ▼
                                        127.0.0.1:5000  carnet.py
                                        (service systemd, compte carnet)
                                                  │
                                                  ▼
                                        /var/lib/carnet (750, carnet)

POURQUOI CHAQUE CHOIX

  - Un compte système dédié, sans shell : si l'application est piratée,
    l'attaquant n'a que les droits de « carnet », et aucun shell.
  - L'application n'écoute que sur 127.0.0.1 : elle n'est joignable
    qu'à travers nginx, qui gère le TLS, les journaux, les en-têtes.
  - systemd la surveille : démarrage au boot, relance en cas de plantage,
    journaux dans journalctl -u carnet.
  - Le pare-feu en liste blanche : un service oublié (le 9090) n'est
    pas exposé par accident. C'est la défense en profondeur.

POUR ALLER PLUS LOIN

  - Durcir l'unité systemd : ProtectSystem=strict, PrivateTmp=yes,
    NoNewPrivileges=yes, ReadWritePaths=/var/lib/carnet
    (« systemd-analyze security carnet » te note l'unité).
  - Sauvegarder /var/lib/carnet chaque nuit (module 01 !) et tester la
    restauration.
  - Surveiller : que se passe-t-il si le disque se remplit, si le
    certificat expire ? Le lab final-02 va te le montrer...
  - Automatiser tout ça (Ansible) : c'est le métier d'infra moderne.
    Tu sais maintenant ce que l'outil fait à ta place.
