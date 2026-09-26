# shellcheck shell=bash
# Aides pour les labs nginx du module 09.

# web_sites_desactiver : désactive tous les sites nginx (ceux des labs, la page
# par défaut de Debian, et ceux que tu as pu créer toi-même).
web_sites_desactiver() {
  find /etc/nginx/sites-enabled -mindepth 1 -delete 2>/dev/null || true
}

# web_site <nom> : active le site /etc/nginx/sites-available/<nom>, et lui seul.
web_site() {
  web_sites_desactiver
  ln -sf "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
  nginx -t -q
  systemctl enable nginx &>/dev/null || true
  systemctl reset-failed nginx &>/dev/null || true
  systemctl restart nginx
}

# web_hosts_retirer <nom> : retire <nom> de /etc/hosts. Seul le nom est retiré
# d'une ligne qui en contient d'autres (« 127.0.0.1 localhost <nom> » garde
# localhost). Écriture « en place » : /etc/hosts peut être un point de montage
# dans un conteneur.
web_hosts_retirer() {
  local hosts
  hosts=$(awk -v n="$1" '
    /^[[:space:]]*#/ { print; next }
    { found = 0; for (i = 2; i <= NF; i++) if ($i == n) found = 1 }
    !found { print; next }
    { line = $1; k = 0
      for (i = 2; i <= NF; i++) { if ($i ~ /^#/) break; if ($i != n) { line = line " " $i; k++ } }
      if (k) print line }' /etc/hosts)
  printf '%s\n' "$hosts" > /etc/hosts
}

# web_hosts <nom> [adresse] : fait pointer <nom> vers 127.0.0.1 (ou l'adresse
# donnée) dans /etc/hosts.
web_hosts() {
  web_hosts_retirer "$1"
  printf '%-15s %s\n' "${2:-127.0.0.1}" "$1" >> /etc/hosts
}

# web_code <url> [options curl] : code HTTP renvoyé (000 si pas de réponse).
# Réessaie pendant 3 s tant que ce n'est pas un 200 : juste après un reload,
# les anciens workers de nginx peuvent encore répondre.
web_code() {
  local code _
  for _ in 1 2 3 4; do
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "$@" || true)
    [[ $code == 200 ]] && break
    sleep 1
  done
  echo "$code"
}
