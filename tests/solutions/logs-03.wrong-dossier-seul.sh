#!/usr/bin/env bash
# Créer /var/log/journal ne suffit pas : Storage=volatile l'emporte.
mkdir -p /var/log/journal
systemctl restart systemd-journald
