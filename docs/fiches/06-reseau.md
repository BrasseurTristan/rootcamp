# 06 · Réseau

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait les labs du module, avec tes
    propres mots. Les questions ci-dessous servent de fil conducteur :
    remplace-les par tes explications au fur et à mesure.

## Adresses et interfaces

- Qu'est-ce qu'une adresse IP, un masque (`/24`), une passerelle ?
- Que montre `ip addr` ? Qu'est-ce que l'interface `lo` ?
- Quelle différence entre écouter sur `127.0.0.1`, sur une adresse précise
  et sur `0.0.0.0` ?

## Ports et services

- Qu'est-ce qu'un port ? Comment voir qui écoute où (`ss -tlnp`) ?
- « Connection refused » ou « timeout » : que signifie chacun ?
- Comment tester un port (`curl`, `nc -zv`) ?

## Noms

- Comment Linux transforme-t-il un nom en adresse (`/etc/nsswitch.conf`,
  `/etc/hosts`, `/etc/resolv.conf`) ?
- Pourquoi `dig` et `getent hosts` peuvent-ils donner des réponses
  différentes ?

## Routage

- Qu'est-ce qu'une table de routage ? Que fait la route `default` ?
- Qu'est-ce qu'un routeur ? À quoi sert `net.ipv4.ip_forward` ?
- Pourquoi faut-il penser à la route de retour ?
- Comment voir les paquets qui passent (`tcpdump`) ?

## Pare-feu

- Comment nftables organise-t-il ses règles (tables, chaînes, hooks,
  policy) ?
- Pourquoi l'ordre des règles compte-t-il ?
- Quelle différence entre `drop` et `reject` ?
- Pourquoi `nft list ruleset` et `/etc/nftables.conf` peuvent-ils différer ?
- Comment modifier le pare-feu d'un serveur distant sans se couper l'accès ?

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `reseau-01` | débutant | L'intranet injoignable (adresse d'écoute, `ss`) |
| `reseau-02` | débutant | La base de données introuvable (`/etc/hosts`, `nsswitch.conf`) |
| `reseau-03` | intermédiaire | Le serveur qui ne route pas (`ip route`, `ip_forward`, route de retour) |
| `reseau-04` | avancé | Le pare-feu à l'envers (nftables, liste blanche) |
