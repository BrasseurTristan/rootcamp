# shellcheck shell=bash
# Aides pour les labs nginx du module 09.

# web_site <nom> : active le site /etc/nginx/sites-available/<nom> et désactive
# les autres sites des labs (et la page par défaut de Debian).
web_site() {
  rm -f /etc/nginx/sites-enabled/{default,compta,appli,compta-tls}
  ln -sf "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
  nginx -t -q
  systemctl enable nginx &>/dev/null || true
  systemctl reset-failed nginx &>/dev/null || true
  systemctl restart nginx
}

# web_hosts <nom> : fait pointer <nom> vers 127.0.0.1 dans /etc/hosts (écriture
# « en place » : /etc/hosts peut être un point de montage dans un conteneur).
web_hosts() {
  local hosts
  hosts=$(grep -vw "$1" /etc/hosts)
  printf '%s\n127.0.0.1       %s\n' "$hosts" "$1" > /etc/hosts
}

# web_code <url> [options curl] : code HTTP renvoyé (000 si pas de réponse).
web_code() { curl -s -o /dev/null -w '%{http_code}' --max-time 5 "$@" || true; }
