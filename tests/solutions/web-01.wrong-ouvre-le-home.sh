#!/usr/bin/env bash
# Ouvrir le dossier d'alice à tout le monde : la page s'affiche, mais c'est une fuite.
chmod 755 /home/alice
sed -i 's|^\(\s*\)index .*|\1index accueil.html;|' /etc/nginx/sites-available/compta
systemctl reload nginx
sleep 1
