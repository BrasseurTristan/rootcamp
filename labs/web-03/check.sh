#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/web.sh
source "$RC_LIB/web.sh"

crt=/etc/ssl/compta/compta.crt
key=/etc/ssl/compta/compta.key
ca=/srv/pki/ca.crt
[[ -f $ca ]] || rc_die "La CA interne a disparu ! Relance le lab avec 'rootcamp reset'."

expect_ok "la configuration de nginx est valide (nginx -t)" nginx -t -q

# Le certificat et sa clé
if [[ -f $crt ]] && openssl verify -CAfile "$ca" "$crt" &>/dev/null; then
  ok "$crt est signé par la CA interne"
else
  ko "$crt existe et est signé par la CA interne"
fi
if [[ -f $crt ]] && openssl x509 -in "$crt" -noout -ext subjectAltName 2>/dev/null | grep -q 'DNS:compta.interne'; then
  ok "le certificat est valable pour le nom compta.interne (subjectAltName)"
else
  ko "le certificat est valable pour le nom compta.interne (subjectAltName)"
fi
if [[ -f $key && $(stat -c %U "$key") == root ]] && (( (8#$(stat -c %a "$key") & 077) == 0 )); then
  ok "la clé privée $key n'est lisible que par root"
else
  ko "la clé privée $key existe et n'est lisible que par root"
fi

# Le site
expect_ok "https://compta.interne/ répond, avec un certificat reconnu par les postes de l'entreprise" \
  sh -c "curl -fsS --max-time 5 --cacert '$ca' https://compta.interne/ | grep -q 'Espace Compta'"
served=$(openssl s_client -connect 127.0.0.1:443 -servername compta.interne </dev/null 2>/dev/null \
  | openssl x509 -noout -fingerprint -sha256 2>/dev/null || true)
expected=$(openssl x509 -in "$crt" -noout -fingerprint -sha256 2>/dev/null || true)
if [[ -n $served && $served == "$expected" ]]; then
  ok "nginx présente bien le certificat $crt"
else
  ko "nginx présente bien le certificat $crt"
fi
redirect=$(curl -s -o /dev/null -w '%{http_code} %{redirect_url}' --max-time 5 http://compta.interne/page?x=1 || true)
if [[ $redirect == "301 https://compta.interne/page?x=1" ]]; then
  ok "http://compta.interne/… redirige (301) vers la même adresse en https"
else
  ko "http://compta.interne/… redirige (301) vers la même adresse en https (obtenu : ${redirect:-rien})"
fi

rc_result
