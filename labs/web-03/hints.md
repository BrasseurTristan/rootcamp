Il y a trois étapes :

  1. créer une clé privée et une DEMANDE de certificat (CSR) pour
     compta.interne
  2. faire signer la demande par la CA interne → le certificat
  3. configurer nginx : un serveur HTTPS (port 443) avec la clé et le
     certificat, et le serveur HTTP (port 80) qui redirige

Tout se fait avec openssl. Regarde d'abord le certificat de la CA :

    openssl x509 -in /srv/pki/ca.crt -noout -text | head -20
---
Les navigateurs et curl ne regardent plus le « CN » du certificat,
seulement l'extension subjectAltName (SAN). Il faut l'ajouter au
moment de la signature :

    sudo mkdir -p /etc/ssl/compta && cd /etc/ssl/compta
    sudo openssl req -new -newkey rsa:2048 -nodes \
         -keyout compta.key -out compta.csr -subj "/CN=compta.interne"
    echo "subjectAltName=DNS:compta.interne" | sudo tee san.ext
    sudo openssl x509 -req -in compta.csr -days 365 \
         -CA /srv/pki/ca.crt -CAkey /srv/pki/ca.key -CAcreateserial \
         -extfile san.ext -out compta.crt
    sudo chmod 600 compta.key
---
Dans /etc/nginx/sites-available/compta-tls :

    server {
        listen 443 ssl;
        server_name compta.interne;
        ssl_certificate     /etc/ssl/compta/compta.crt;
        ssl_certificate_key /etc/ssl/compta/compta.key;
        root /var/www/compta-tls;
        index index.html;
    }

    server {
        listen 80 default_server;
        server_name compta.interne;
        return 301 https://$host$request_uri;
    }

puis : sudo nginx -t && sudo systemctl reload nginx
