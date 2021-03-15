#!/bin/sh
set -exo pipefail

if [ ! -f ~/.radicle-seed/secret.key ]; then
    if [ ! -d ~/.radicle-seed ]; then
        mkdir -p ~/.radicle-seed
    fi
    radicle-keyutil --filename ~/.radicle-seed/secret.key
fi

if [ ! -z ${public_addr} ]; then
    public_addr="--public-addr ${public_addr}"
fi

if [ ! -z "${description}" ]; then
    description="${description}"
else 
    description=""
fi

radicle-seed-node --root ~/.radicle-seed --peer-listen ${peer_listen} --http-listen ${http_listen} --name ${name} ${public_addr} --description "${description}" --assets-path /var/www < ~/.radicle-seed/secret.key