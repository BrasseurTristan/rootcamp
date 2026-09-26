Ton premier vrai projet : mettre en production le « carnet de notes »
de l'équipe, une petite application web. Le développeur a livré :

    /opt/carnet/carnet.py        l'application (Python)
    /etc/carnet/carnet.conf      sa configuration

  Elle écoute sur 127.0.0.1:5000 et range ses notes dans /var/lib/carnet.
  Tout le reste est à faire. Voici le cahier des charges.

LE COMPTE ET LE SERVICE

  - un compte système « carnet », sans shell de connexion
  - /var/lib/carnet appartient à carnet, et n'est pas ouvert à tous
  - un service systemd « carnet » : il lance l'application avec le compte
    carnet, démarre avec le serveur, et redémarre si elle plante

LE WEB

  - nginx publie l'application sur https://carnet.interne, avec un
    certificat signé par la CA interne (/srv/pki, voir lab web-03)
  - clé et certificat : /etc/ssl/carnet/carnet.key et carnet.crt,
    la clé lisible seulement par root
  - http:// redirige vers https://
  - l'application reçoit l'adresse des clients (X-Forwarded-For)

LE PARE-FEU

  - seuls SSH, HTTP et HTTPS sont joignables depuis le réseau (un
    service de débogage tourne sur le port 9090 : il ne doit pas être
    accessible) ; la configuration survit à un redémarrage
  - le poste d'Alice (sudo ip netns exec poste-alice ...) doit pouvoir
    utiliser le carnet via 10.10.0.1

POUR TESTER

    curl --cacert /srv/pki/ca.crt https://carnet.interne/
    curl --cacert /srv/pki/ca.crt -d "ma première note" https://carnet.interne/notes

  Prends ton temps, relis tes fiches, et vérifie étape par étape avec
  « rootcamp check » : il te dit ce qui manque encore.
