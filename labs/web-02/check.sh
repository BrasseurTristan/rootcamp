#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/web.sh
source "$RC_LIB/web.sh"

expect_ok "la configuration de nginx est valide (nginx -t)" nginx -t -q
expect_ok "l'application des commandes tourne" systemctl is-active --quiet appli-commandes
expect_ok "l'application redémarrera avec le serveur" systemctl is-enabled --quiet appli-commandes
code=$(web_code http://localhost/)
if [[ $code == 200 ]]; then
  ok "http://localhost/ répond (code $code)"
else
  ko "http://localhost/ répond (code $code)"
fi
page=$(curl -fsS --max-time 5 http://localhost/ 2>/dev/null || true)
if grep -q "Appli des commandes" <<<"$page"; then
  ok "c'est bien l'application des commandes qui répond, à travers nginx"
else
  ko "c'est bien l'application des commandes qui répond, à travers nginx"
fi
if grep -q "client : 127.0.0.1" <<<"$page"; then
  ok "l'application reçoit l'adresse du client (en-tête X-Forwarded-For)"
else
  ko "l'application reçoit l'adresse du client (en-tête X-Forwarded-For)"
fi

rc_result
