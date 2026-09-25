CE QU'IL FALLAIT FAIRE

    cd /etc/ssl/compta
    openssl req -new -newkey rsa:2048 -nodes -keyout compta.key \
            -out compta.csr -subj "/CN=compta.interne"
    openssl x509 -req -in compta.csr -days 365 \
            -CA /srv/pki/ca.crt -CAkey /srv/pki/ca.key -CAcreateserial \
            -extfile <(echo "subjectAltName=DNS:compta.interne") -out compta.crt
    chmod 600 compta.key

  puis un serveur nginx « listen 443 ssl » avec ssl_certificate et
  ssl_certificate_key, et « return 301 https://$host$request_uri; »
  sur le port 80.

POURQUOI ÇA MARCHE

  HTTPS = HTTP dans un tunnel TLS. Le TLS apporte deux choses :
    - le CHIFFREMENT (personne ne lit les échanges sur le réseau)
    - l'AUTHENTIFICATION du serveur : le certificat prouve que tu parles
      bien à compta.interne, parce qu'il est signé par une autorité (CA)
      à laquelle le client fait confiance.

  La chaîne : le poste fait confiance à la CA → la CA a signé le
  certificat de compta.interne → le serveur prouve qu'il possède la clé
  privée qui va avec. La clé privée ne quitte JAMAIS le serveur ; la
  CSR, elle, ne contient que la clé publique et le nom demandé.

  Un certificat auto-signé chiffre aussi, mais personne ne peut
  vérifier qu'il n'a pas été fabriqué par un attaquant.

À RETENIR

  - Clé privée → CSR → signature par une CA → certificat.
  - Le nom doit être dans le subjectAltName, pas seulement dans le CN.
  - openssl x509 -in cert.crt -noout -text : lire un certificat.
    openssl s_client -connect hôte:443 : voir ce que présente un serveur.
  - Sur Internet, Let's Encrypt (certbot) délivre et renouvelle
    automatiquement des certificats reconnus partout, gratuitement.
  - Surveille les dates d'expiration : un certificat expiré, c'est un
    site inaccessible.
