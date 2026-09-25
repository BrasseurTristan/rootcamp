#!/usr/bin/env bash
# De la place, oui… en supprimant aussi des données à conserver.
rm -rf /srv/donnees/exports
systemctl stop exporteur
