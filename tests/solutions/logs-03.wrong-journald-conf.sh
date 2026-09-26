#!/usr/bin/env bash
# Modifié dans journald.conf : le fichier de journald.conf.d/, lu après, l'emporte.
printf 'Storage=persistent\nSystemMaxUse=500M\n' >> /etc/systemd/journald.conf
systemctl restart systemd-journald
