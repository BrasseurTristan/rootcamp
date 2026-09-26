#!/usr/bin/env bash
set -euo pipefail
rm /srv/donnees/exports/tmp/*
systemctl stop exporteur
