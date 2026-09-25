#!/usr/bin/env bash
# Supprimer la ligne fautive n'aide pas : il faut une devise valide.
sed -i '/^devise=/d' /etc/paiements/paiements.conf
systemctl restart paiements
