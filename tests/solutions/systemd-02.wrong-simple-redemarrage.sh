#!/usr/bin/env bash
# Le service repart… jusqu'au prochain plantage.
set -euo pipefail
systemctl start rapports
