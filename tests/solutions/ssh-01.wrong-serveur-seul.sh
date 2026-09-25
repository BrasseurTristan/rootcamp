#!/usr/bin/env bash
# Le serveur est réparé, mais la clé privée est toujours lisible par tous.
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys
