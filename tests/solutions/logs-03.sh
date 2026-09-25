#!/usr/bin/env bash
set -euo pipefail
printf '[Journal]\nStorage=persistent\nSystemMaxUse=500M\n' > /etc/systemd/journald.conf.d/10-economie-disque.conf
systemctl restart systemd-journald
