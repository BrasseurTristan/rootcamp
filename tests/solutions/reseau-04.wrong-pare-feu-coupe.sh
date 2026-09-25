#!/usr/bin/env bash
# « Plus de pare-feu, plus de problème »… et plus de protection.
systemctl disable --now nftables
nft flush ruleset
