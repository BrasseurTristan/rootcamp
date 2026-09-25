Procède dans l'ordre, et teste chaque couche avant de passer à la
suivante :

  1. le compte et le dossier de données          (module 02)
  2. le service systemd, puis curl http://127.0.0.1:5000   (module 03)
  3. le certificat et nginx                       (module 09, web-03)
  4. le pare-feu                                  (module 06, reseau-04)

« rootcamp check » te dit ce qui manque : sers-t'en comme d'une liste.
---
Le compte et le service :

    sudo useradd --system --home-dir /var/lib/carnet --shell /usr/sbin/nologin carnet
    sudo install -d -o carnet -g carnet -m 750 /var/lib/carnet

Une unité avec User=carnet, ExecStart=/opt/carnet/carnet.py,
Restart=on-failure et WantedBy=multi-user.target, puis
« systemctl enable --now carnet ». Vérifie avec journalctl -u carnet.
---
nginx : un serveur « listen 443 ssl » pour carnet.interne avec
ssl_certificate / ssl_certificate_key et un « location / » qui fait
proxy_pass vers http://127.0.0.1:5000 (avec proxy_set_header
X-Forwarded-For), plus un serveur sur le port 80 qui fait
« return 301 https://$host$request_uri; ».

Pare-feu : /etc/nftables.conf avec policy drop en entrée, lo et
established acceptés, puis « tcp dport { 22, 80, 443 } accept ».
N'oublie pas « systemctl enable nftables ».
