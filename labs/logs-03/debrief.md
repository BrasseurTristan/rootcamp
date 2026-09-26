CE QUI ÉTAIT CASSÉ

  /etc/systemd/journald.conf.d/10-economie-disque.conf contenait
  Storage=volatile : le journal ne vivait qu'en mémoire (/run/log/journal)
  et disparaissait à chaque redémarrage. Impossible d'enquêter sur un
  plantage.

UNE SOLUTION

  Dans /etc/systemd/journald.conf.d/10-economie-disque.conf :

    [Journal]
    Storage=persistent
    SystemMaxUse=500M

  puis :

    sudo systemctl restart systemd-journald

POURQUOI ÇA MARCHE

  journald lit journald.conf puis les fichiers de journald.conf.d/ par
  ordre alphabétique ; pour chaque option, la dernière valeur l'emporte.
  C'est le fonctionnement de la plupart des services systemd (et
  l'inverse de sshd, où la première valeur gagne !).

  Avec Storage=persistent, les journaux vont dans /var/log/journal, et
  « journalctl -b -1 » montre le démarrage précédent. SystemMaxUse
  empêche le journal de remplir le disque : journald supprime les plus
  vieilles entrées au-delà de la limite. C'était la vraie solution au
  « ticket INFRA-812 ».

À RETENIR

  - Storage=persistent + SystemMaxUse : une bonne base sur un serveur.
  - journalctl --list-boots, -b -1 (démarrage précédent),
    --disk-usage, --vacuum-size=200M (faire de la place tout de suite).
  - systemd-analyze cat-config <fichier> : la configuration complète,
    avec tous les fichiers de surcharge, pour n'importe quel composant
    de systemd.
  - Le meilleur réflexe après un plantage : journalctl -b -1 -p err.
