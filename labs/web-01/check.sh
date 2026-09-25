#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/web.sh
source "$RC_LIB/web.sh"

expect_ok "la configuration de nginx est valide (nginx -t)" nginx -t -q
expect_ok "nginx est démarré" systemctl is-active --quiet nginx
code=$(web_code http://localhost/)
if [[ $code == 200 ]]; then
  ok "http://localhost/ répond (code $code)"
else
  ko "http://localhost/ répond (code $code)"
fi
expect_ok "la page affichée est l'Espace Compta" sh -c 'curl -fsS --max-time 5 http://localhost/ | grep -q "Espace Compta"'
if nginx -T 2>/dev/null | grep -qE '^[[:space:]]*root[[:space:]]+/var/www/compta/?;'; then
  ok "le site est servi depuis /var/www/compta"
else
  ko "le site est servi depuis /var/www/compta (règle de l'équipe)"
fi
if [[ -d /home/alice ]] && (( (8#$(stat -c %a /home/alice) & 7) == 0 )); then
  ok "le dossier personnel d'alice reste privé"
else
  ko "le dossier personnel d'alice reste privé"
fi

rc_result
