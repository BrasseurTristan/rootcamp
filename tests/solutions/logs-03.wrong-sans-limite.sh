#!/usr/bin/env bash
# Persistant, mais sans limite de taille.
printf '[Journal]\nStorage=persistent\n' > /etc/systemd/journald.conf.d/10-economie-disque.conf
systemctl restart systemd-journald
