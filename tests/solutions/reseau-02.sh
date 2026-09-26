#!/usr/bin/env bash
set -euo pipefail
hosts=$(sed 's/^10\.20\.0\.99 .*db\.interne.*/10.20.0.2 db.interne/' /etc/hosts)
echo "$hosts" > /etc/hosts
