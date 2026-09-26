CE QUI ÉTAIT CASSÉ

  /etc/paiements/paiements.conf contenait « devise=EURO » au lieu de
  « devise=EUR ». Le service écrivait l'erreur, puis 150 lignes
  d'arrêt : « systemctl status » ne montrait que ces dernières.

UNE SOLUTION

    journalctl -u paiements -p err -n 5
    sudo sed -i 's/^devise=.*/devise=EUR/' /etc/paiements/paiements.conf
    sudo systemctl restart paiements

POURQUOI ÇA MARCHE

  journald collecte les messages de tous les services (leur sortie
  standard et d'erreur), du noyau et de syslog, avec pour chacun :
  la date, le service, le PID... et une PRIORITÉ :

    0 emerg  1 alert  2 crit  3 err  4 warning  5 notice  6 info  7 debug

  « -p err » affiche les priorités 0 à 3. Un programme bien écrit
  marque ses erreurs comme telles : c'est le filtre le plus efficace.

À RETENIR

  - Le diagnostic commence TOUJOURS par les logs, et ne s'arrête pas
    aux dernières lignes.
  - journalctl : -u (service), -p (priorité), -b (démarrage), --since /
    --until (période), -g (motif), -f (en direct), -o json (tout voir).
  - Quand plusieurs services sont en cause : journalctl -p err -b
    donne toutes les erreurs du démarrage, tous services confondus.
  - Un service qui « redémarre en boucle » cache souvent l'erreur
    initiale sous les messages des tentatives suivantes.
