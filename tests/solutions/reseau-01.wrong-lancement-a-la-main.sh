#!/usr/bin/env bash
# Un serveur lancé à la main à côté du service : il mourra à la déconnexion.
systemctl stop intranet
systemd-run --quiet --unit=rc-intranet-a-la-main python3 -m http.server --bind 0.0.0.0 --directory /srv/intranet 8080
sleep 1
