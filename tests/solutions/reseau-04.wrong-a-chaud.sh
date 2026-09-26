#!/usr/bin/env bash
# Corrigé à chaud avec nft : perdu au prochain redémarrage du pare-feu.
nft insert rule inet filtre entree tcp dport 8080 accept
handle=$(nft -a list chain inet filtre entree | awk '/dport 3306/ {print $NF}')
nft delete rule inet filtre entree handle "$handle"
