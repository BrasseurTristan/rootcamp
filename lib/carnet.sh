# shellcheck shell=bash
# L'application « carnet » des labs du module 10, et tout ce qu'il faut pour
# la déployer, la démonter et la vérifier. À charger après lib/lab.sh,
# lib/reseau.sh et lib/web.sh.

CARNET_URL=https://carnet.interne
CARNET_CA=/srv/pki/ca.crt

# carnet_appli : installe le code de l'application et sa configuration.
carnet_appli() {
  mkdir -p /opt/carnet /etc/carnet
  cat > /opt/carnet/carnet.py <<'PY'
#!/usr/bin/env python3
"""Carnet de notes partagé (application des labs finaux de rootcamp)."""
import os
import pwd
from http.server import BaseHTTPRequestHandler, HTTPServer

conf = {}
with open("/etc/carnet/carnet.conf") as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            key, value = line.split("=", 1)
            conf[key.strip()] = value.strip()

PORT = int(conf.get("PORT", "5000"))
DONNEES = conf.get("DONNEES", "/var/lib/carnet")
NOTES = os.path.join(DONNEES, "notes.txt")


class Carnet(BaseHTTPRequestHandler):
    def repondre(self, code, texte):
        body = texte.encode()
        self.send_response(code)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        try:
            with open(NOTES) as f:
                nb = sum(1 for _ in f)
        except FileNotFoundError:
            nb = 0
        except PermissionError:
            return self.repondre(500, "Erreur : impossible de lire les notes\n")
        client = self.headers.get("X-Forwarded-For", "inconnu")
        utilisateur = pwd.getpwuid(os.getuid()).pw_name
        self.repondre(200, f"Carnet de notes : {nb} note(s)\n"
                           f"client : {client}\nutilisateur : {utilisateur}\n")

    def do_POST(self):
        taille = int(self.headers.get("Content-Length", "0"))
        note = self.rfile.read(taille).decode(errors="replace").strip()
        try:
            with open(NOTES, "a") as f:
                f.write(note.replace("\n", " ") + "\n")
        except OSError as e:
            print(f"ERREUR : impossible d'enregistrer la note dans {NOTES} : {e}", flush=True)
            return self.repondre(500, "Erreur : note non enregistrée\n")
        self.repondre(201, "Note enregistrée\n")


print(f"carnet : écoute sur 127.0.0.1:{PORT}, données dans {DONNEES}", flush=True)
HTTPServer(("127.0.0.1", PORT), Carnet).serve_forever()
PY
  chmod 755 /opt/carnet/carnet.py
  cat > /etc/carnet/carnet.conf <<'CONF'
# Configuration du carnet de notes
PORT=5000
DONNEES=/var/lib/carnet
CONF
}

# carnet_ca : (re)crée l'autorité de certification interne dans /srv/pki.
carnet_ca() {
  rm -rf /srv/pki
  mkdir -p /srv/pki
  openssl req -x509 -newkey rsa:2048 -nodes -days 3650 -sha256 \
    -subj "/O=Entreprise/CN=CA interne de l'entreprise" \
    -keyout /srv/pki/ca.key -out /srv/pki/ca.crt 2>/dev/null
  chmod 600 /srv/pki/ca.key
}

# carnet_nettoyer : démonte tout (service, compte, site, certificats, pare-feu).
carnet_nettoyer() {
  systemctl disable --now carnet &>/dev/null || true
  systemctl reset-failed carnet &>/dev/null || true
  rm -rf /etc/systemd/system/carnet.service /etc/systemd/system/carnet.service.d
  systemctl daemon-reload
  if id carnet &>/dev/null; then rc_supprimer_user carnet; fi
  # Le groupe survit à userdel s'il a d'autres membres (« usermod -aG carnet … »).
  if getent group carnet >/dev/null; then groupdel -f carnet; fi
  rm -rf /var/lib/carnet /etc/ssl/carnet /opt/carnet /etc/carnet
  rm -f /etc/nginx/sites-enabled/carnet /etc/nginx/sites-available/carnet
  reseau_parefeu_ouvert
  systemctl disable nftables &>/dev/null || true
}

# carnet_environnement : le poste d'Alice, un service de débogage (qui ne
# doit pas être exposé) et le nom carnet.interne.
carnet_environnement() {
  reseau_machine poste-alice 10.10.0.1 10.10.0.2
  reseau_liberer_port 9090
  reseau_service rc-debug nc -lk 9090
  web_hosts carnet.interne
}

# carnet_deployer : le déploiement de référence, complet et correct.
carnet_deployer() {
  useradd --system --home-dir /var/lib/carnet --shell /usr/sbin/nologin carnet
  install -d -o carnet -g carnet -m 750 /var/lib/carnet
  cat > /etc/systemd/system/carnet.service <<'UNIT'
[Unit]
Description=Carnet de notes
After=network.target

[Service]
User=carnet
ExecStart=/opt/carnet/carnet.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
UNIT
  systemctl daemon-reload
  systemctl enable --now carnet &>/dev/null

  mkdir -p /etc/ssl/carnet
  openssl req -new -newkey rsa:2048 -nodes -subj "/CN=carnet.interne" \
    -keyout /etc/ssl/carnet/carnet.key -out /etc/ssl/carnet/carnet.csr 2>/dev/null
  openssl x509 -req -in /etc/ssl/carnet/carnet.csr -days 365 \
    -CA /srv/pki/ca.crt -CAkey /srv/pki/ca.key -CAcreateserial \
    -extfile <(echo "subjectAltName=DNS:carnet.interne") -out /etc/ssl/carnet/carnet.crt 2>/dev/null
  chmod 600 /etc/ssl/carnet/carnet.key

  cat > /etc/nginx/sites-available/carnet <<'CONF'
server {
    listen 443 ssl;
    server_name carnet.interne;
    ssl_certificate     /etc/ssl/carnet/carnet.crt;
    ssl_certificate_key /etc/ssl/carnet/carnet.key;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 80 default_server;
    server_name carnet.interne;
    return 301 https://$host$request_uri;
}
CONF
  web_site carnet

  cat > /etc/nftables.conf <<'NFT'
#!/usr/sbin/nft -f
flush ruleset

table inet filtre {
  chain entree {
    type filter hook input priority filter; policy drop;
    iif lo accept
    ct state established,related accept
    meta l4proto { icmp, ipv6-icmp } accept
    tcp dport { 22, 80, 443 } accept
  }
}
NFT
  systemctl enable nftables &>/dev/null
  systemctl reset-failed nftables &>/dev/null || true
  systemctl restart nftables
  rc_retry 10 carnet_repond
}

# carnet_repond : vrai si le carnet répond en HTTPS depuis le serveur.
carnet_repond() { curl -fsS --max-time 3 --cacert "$CARNET_CA" "$CARNET_URL/" &>/dev/null; }

# carnet_verifier : l'état de santé complet, vu de l'extérieur autant que possible.
carnet_verifier() {
  local page redirect note code
  expect_ok "le service carnet tourne" systemctl is-active --quiet carnet
  expect_ok "le service carnet redémarrera avec le serveur" systemctl is-enabled --quiet carnet
  if [[ -d /var/lib/carnet && $(stat -c %U /var/lib/carnet) == carnet ]] \
     && (( (8#$(stat -c %a /var/lib/carnet) & 7) == 0 )); then
    ok "le dossier de données appartient au compte carnet et n'est pas ouvert à tous"
  else
    ko "le dossier de données appartient au compte carnet et n'est pas ouvert à tous"
  fi
  expect_ok "la configuration de nginx est valide (nginx -t)" nginx -t -q

  page=$(curl -fsS --max-time 5 --cacert "$CARNET_CA" "$CARNET_URL/" 2>/dev/null || true)
  if grep -q "Carnet de notes" <<<"$page"; then
    ok "$CARNET_URL/ répond, avec un certificat reconnu"
  else
    ko "$CARNET_URL/ répond, avec un certificat reconnu"
  fi
  if grep -q "utilisateur : carnet" <<<"$page"; then
    ok "l'application tourne avec le compte carnet"
  else
    ko "l'application tourne avec le compte carnet"
  fi
  if grep -q "client : 127.0.0.1" <<<"$page"; then
    ok "l'application reçoit l'adresse des clients (X-Forwarded-For)"
  else
    ko "l'application reçoit l'adresse des clients (X-Forwarded-For)"
  fi
  note="verification-rootcamp-$RANDOM"
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 --cacert "$CARNET_CA" -d "$note" "$CARNET_URL/notes" || true)
  if [[ $code == 201 ]] && grep -qs "$note" /var/lib/carnet/notes.txt; then
    ok "on peut enregistrer une note"
  else
    ko "on peut enregistrer une note (code $code)"
  fi
  redirect=$(curl -s -o /dev/null -w '%{http_code} %{redirect_url}' --max-time 5 http://carnet.interne/test || true)
  if [[ $redirect == "301 https://carnet.interne/test" ]]; then
    ok "http:// redirige vers https://"
  else
    ko "http:// redirige vers https:// (obtenu : ${redirect:-rien})"
  fi

  # Le pare-feu, rechargé depuis sa configuration comme au démarrage
  local valide=0
  if nft -c -f /etc/nftables.conf &>/dev/null; then valide=1; fi
  if (( valide )) && systemctl is-enabled --quiet nftables; then
    ok "le pare-feu est valide et chargé au démarrage"
  else
    ko "le pare-feu est valide et chargé au démarrage"
  fi
  # Testé sur une machine jetable avant d'être appliqué : une règle qui
  # bloque SSH couperait ta connexion à la VM.
  if (( valide )) && reseau_parefeu_laisse_ssh /etc/nftables.conf; then
    ok "SSH (port 22) reste autorisé par le pare-feu, depuis n'importe quelle adresse"
    systemctl reset-failed nftables &>/dev/null || true
    systemctl restart nftables &>/dev/null || true
  else
    ko "SSH (port 22) reste autorisé par le pare-feu, depuis n'importe quelle adresse"
    if (( valide )); then echo "    (pare-feu non rechargé : il t'aurait coupé l'accès à la VM)"; fi
  fi
  local alice=(ip netns exec poste-alice)
  expect_ok "depuis le poste d'Alice, $CARNET_URL/ répond" \
    "${alice[@]}" curl -fsS --max-time 5 --cacert "$CARNET_CA" --resolve carnet.interne:443:10.10.0.1 -o /dev/null "$CARNET_URL/"
  expect_fail "depuis le poste d'Alice, les autres ports sont fermés (ex. 9090)" \
    "${alice[@]}" nc -z -w 2 10.10.0.1 9090
}
