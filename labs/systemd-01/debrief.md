CE QUI ÉTAIT CASSÉ

  Dans /etc/systemd/system/facturation-api.service :

    ExecStart=/usr/local/bin/facturation_api   → le programme s'appelle
                                                 facturation-api (tiret)
    User=factu                                 → l'utilisateur est facturation

  Et le service n'était pas activé (« disabled ») : même réparé, il ne
  serait pas revenu après un redémarrage.

UNE SOLUTION

    sudo systemctl edit --full facturation-api
      (corriger ExecStart= et User=)
    sudo systemctl enable --now facturation-api
    systemctl status facturation-api

POURQUOI ÇA MARCHE

  systemd est le premier programme lancé par le noyau (PID 1). Il
  démarre et surveille tous les services, décrits par des « unités » :

    [Unit]     description et dépendances (After=, Requires=...)
    [Service]  comment lancer le programme (ExecStart=, User=...)
    [Install]  quand l'activer (WantedBy=multi-user.target = au
               démarrage normal de la machine)

  « enable » crée un lien dans multi-user.target.wants/ : c'est ce qui
  fait démarrer le service au boot. « start » le lance maintenant.
  Les deux sont indépendants !

À RETENIR

  - systemctl status + journalctl -u : TOUJOURS commencer par là.
  - Les codes status=203/EXEC (programme introuvable ou non
    exécutable) et 217/USER (utilisateur inconnu) reviennent souvent.
  - Après avoir modifié une unité à la main : systemctl daemon-reload.
    (« systemctl edit » le fait pour toi.)
  - Les unités de l'admin vont dans /etc/systemd/system/, celles des
    paquets dans /usr/lib/systemd/system/ : on ne touche pas à ces
    dernières (c'est le sujet du lab suivant).
  - Un service n'a presque jamais besoin de tourner en root : un
    utilisateur dédié limite les dégâts en cas de faille.
