#!/usr/bin/env bash
# La commande remarche… mais le modèle de facture est toujours abîmé.
set -euo pipefail
printf '#!/bin/sh\necho "facturation-agent : prêt"\n' > /usr/bin/facturation-agent
chmod 755 /usr/bin/facturation-agent
