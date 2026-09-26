Ticket de l'équipe sécurité :

    De : Sécurité
    Objet : compta.interne en HTTP : les mots de passe circulent en clair

    Le site http://compta.interne doit passer en HTTPS. Utilisez un
    certificat signé par notre autorité de certification interne : tous
    les postes de l'entreprise lui font déjà confiance.

  L'autorité de certification (CA) interne :
    /srv/pki/ca.crt   son certificat (public)
    /srv/pki/ca.key   sa clé privée (ultra-secrète, ne la copie nulle part !)

OBJECTIF

  - une clé privée /etc/ssl/compta/compta.key, lisible seulement par root
  - un certificat /etc/ssl/compta/compta.crt pour le nom compta.interne,
    signé par la CA interne
  - https://compta.interne/ affiche le site avec ce certificat
  - http://compta.interne/<n'importe quoi> redirige (301) vers
    https://compta.interne/<la même chose>

POUR TESTER

    curl --cacert /srv/pki/ca.crt https://compta.interne/
    curl -I http://compta.interne/test
