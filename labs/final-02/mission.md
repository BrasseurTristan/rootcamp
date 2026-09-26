Tu es d'astreinte cette nuit. 3 h 12, ton téléphone sonne :

    [CRITIQUE] carnet.interne : service indisponible

  Le carnet de notes (celui de final-01) est en panne. Il y a eu une
  « petite maintenance » hier soir... et personne ne sait exactement ce
  qui a été touché. Plusieurs choses sont peut-être cassées en même temps.

  Rappel de l'architecture :

    poste d'Alice ──► pare-feu ──► nginx :443 (TLS) ──► 127.0.0.1:5000
                                   /etc/ssl/carnet/     service carnet
                                                        /var/lib/carnet

OBJECTIF

  Remettre le carnet en état de marche, entièrement :
    - https://carnet.interne/ répond, depuis le serveur ET depuis le
      poste d'Alice
    - on peut enregistrer des notes
    - rien d'autre n'a été abîmé (pare-feu, droits, redémarrage...)

  Chaque « rootcamp reset » tire de nouvelles pannes au sort : tu peux
  refaire ce lab plusieurs fois !

POUR TESTER

    curl --cacert /srv/pki/ca.crt https://carnet.interne/
    curl --cacert /srv/pki/ca.crt -d "test" https://carnet.interne/notes
