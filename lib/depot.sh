# shellcheck shell=bash
# Le dépôt APT « interne » des labs du module 04 : de vrais paquets .deb,
# un index signé avec GPG, servi en local (file:), sans besoin de réseau.

DEPOT=/srv/depot-interne
DEPOT_SOURCE=/etc/apt/sources.list.d/depot-interne.sources
DEPOT_CLE=/etc/apt/keyrings/depot-interne.asc

# depot_nettoyer : supprime toute trace des labs précédents (paquet, dépôt, clés,
# sources, épinglages).
depot_nettoyer() {
  apt-mark unhold facturation-agent &>/dev/null || true
  dpkg --purge facturation-agent &>/dev/null || true
  { grep -rlE 'depot[-_]interne' /etc/apt/sources.list.d/ 2>/dev/null || true; } | xargs -r rm -f
  rm -rf "$DEPOT" /srv/depot_interne /etc/apt/preferences.d/facturation*   # y compris un lien créé à la main
  rm -f /var/lib/apt/lists/*depot?interne*   # index d'un ancien dépôt : « Hash Sum mismatch »
  rm -f /etc/apt/keyrings/depot-interne* /usr/share/keyrings/depot-interne* /etc/apt/trusted.gpg.d/depot-interne*
  mkdir -p "$DEPOT" /etc/apt/keyrings
}

# depot_paquet <version> : construit facturation-agent_<version>_all.deb dans le dépôt.
depot_paquet() {
  local v=$1 b
  b=$(mktemp -d)
  mkdir -p "$b/DEBIAN" "$b/usr/bin" "$b/usr/share/facturation-agent/modeles"
  cat > "$b/DEBIAN/control" <<CONTROL
Package: facturation-agent
Version: $v
Architecture: all
Maintainer: Équipe infra <infra@exemple.fr>
Description: Agent de facturation de l'entreprise
 Envoie chaque soir les factures du jour à la comptabilité.
CONTROL
  printf '#!/bin/sh\necho "facturation-agent %s : prêt"\n' "$v" > "$b/usr/bin/facturation-agent"
  chmod 755 "$b/usr/bin/facturation-agent"
  printf 'FACTURE N° {{numero}}\nClient : {{client}}\nMontant : {{montant}} €\n' \
    > "$b/usr/share/facturation-agent/modeles/facture.tpl"
  dpkg-deb --build --root-owner-group "$b" "$DEPOT/facturation-agent_${v}_all.deb" >/dev/null
  rm -rf "$b"
}

# depot_index : génère l'index du dépôt (Packages, Release).
depot_index() {
  local f
  for f in "$DEPOT"/*.deb; do
    dpkg-deb --field "$f"
    echo "Filename: ./${f##*/}"
    echo "Size: $(stat -c %s "$f")"
    echo "SHA256: $(sha256sum "$f" | cut -d' ' -f1)"
    echo
  done > "$DEPOT/Packages"
  cat > "$DEPOT/Release" <<RELEASE
Origin: Interne
Label: Depot interne
Date: $(LC_ALL=C date -Ru)
SHA256:
 $(sha256sum "$DEPOT/Packages" | cut -d' ' -f1) $(stat -c %s "$DEPOT/Packages") Packages
RELEASE
}

# depot_publier : génère l'index et le signe (InRelease). La clé publique est
# déposée dans $DEPOT/cle-publique.asc.
depot_publier() {
  depot_index
  local gnupg
  gnupg=$(mktemp -d)
  GNUPGHOME=$gnupg gpg --batch --quiet --passphrase '' \
    --quick-gen-key 'Depot interne <depot@exemple.fr>' ed25519 sign never 2>/dev/null
  GNUPGHOME=$gnupg gpg --batch --quiet --armor --export > "$DEPOT/cle-publique.asc"
  GNUPGHOME=$gnupg gpg --batch --quiet --yes --pinentry-mode loopback --passphrase '' \
    --clearsign -o "$DEPOT/InRelease" "$DEPOT/Release"
  GNUPGHOME=$gnupg gpgconf --kill all 2>/dev/null || true
  rm -rf "$gnupg"
}

# depot_configurer : déclare le dépôt dans APT, correctement.
depot_configurer() {
  cp "$DEPOT/cle-publique.asc" "$DEPOT_CLE"
  cat > "$DEPOT_SOURCE" <<SOURCE
# Dépôt interne de l'entreprise
Types: deb
URIs: file:$DEPOT
Suites: ./
Signed-By: $DEPOT_CLE
SOURCE
  # apt lit l'index du nouveau dépôt (et seulement celui-là : pas de réseau).
  apt-get update -qq -o Dir::Etc::sourcelist="$DEPOT_SOURCE" -o Dir::Etc::sourceparts=- \
    -o APT::Get::List-Cleanup=0 &>/dev/null
}

# depot_candidat_futur : la version que choisirait apt si une 2.3 sortait
# demain dans le dépôt interne, avec les épinglages actuels. La simulation se
# fait dans un dossier temporaire : la vraie configuration d'APT n'est pas touchée.
depot_candidat_futur() {
  local tmp opts
  tmp=$(mktemp -d)
  mkdir -p "$tmp/depot" "$tmp/lists/partial"
  DEPOT=$tmp/depot depot_paquet 2.3
  DEPOT=$tmp/depot depot_index
  printf 'Types: deb\nURIs: file:%s\nSuites: ./\nTrusted: yes\n' "$tmp/depot" > "$tmp/futur.sources"
  opts=(-o Dir::Etc::sourcelist="$tmp/futur.sources" -o Dir::Etc::sourceparts=-
        -o Dir::State::Lists="$tmp/lists" -o Dir::Cache::pkgcache= -o Dir::Cache::srcpkgcache=)
  apt-get update -qq "${opts[@]}" &>/dev/null || true
  LC_ALL=C apt-cache policy "${opts[@]}" facturation-agent 2>/dev/null | awk '/Candidate:/ {print $2}'
  rm -rf "$tmp"
}

# depot_version_installee : version installée de facturation-agent (vide sinon).
depot_version_installee() {
  dpkg-query -W -f='${db:Status-Abbrev} ${Version}' facturation-agent 2>/dev/null | awk '$1 == "ii" {print $2}'
}
