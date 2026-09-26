CE QUI ÉTAIT CASSÉ

  1. Le service appli-commandes était arrêté et désactivé.
  2. proxy_pass visait le port 8000, l'application écoute sur 8081.
     Journal : « connect() failed (111: Connection refused) while
     connecting to upstream ».
  3. nginx ne transmettait pas l'adresse du client.

UNE SOLUTION

    sudo systemctl enable --now appli-commandes

  et dans /etc/nginx/sites-available/appli :

    location / {
        proxy_pass http://127.0.0.1:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

  puis :

    sudo nginx -t && sudo systemctl reload nginx

POURQUOI ÇA MARCHE

  Un reverse proxy est l'unique porte d'entrée : il reçoit toutes les
  requêtes et les relaie aux applications, qui restent cachées derrière
  (ici sur 127.0.0.1). C'est lui qui gère le HTTPS, la compression, les
  journaux, la répartition de charge...

  Mais pour l'application, chaque requête vient désormais de nginx
  (127.0.0.1). L'adresse réelle du client, le nom de domaine demandé
  et le protocole (http ou https) doivent lui être transmis dans des
  en-têtes : X-Forwarded-For, Host, X-Forwarded-Proto.

À RETENIR

  - 502 Bad Gateway : l'application derrière le proxy ne répond pas
    (arrêtée, mauvais port, plantée). 504 Gateway Timeout : elle répond
    trop lentement.
  - Diagnostic : journal d'erreurs de nginx, puis ss -tlnp, puis
    curl directement sur l'application (curl http://127.0.0.1:8081).
  - Les en-têtes X-Forwarded-* sont à ajouter dans quasiment tous les
    reverse proxies.
