#!/bin/sh
set -e

SSL_DIR="/etc/nginx/ssl"
mkdir -p $SSL_DIR

if [ -z "$DOMAIN" ]; then
    echo "ERROR: DOMAIN env variable is not set!"
    exit 1
fi

if [ ! -f "$SSL_DIR/fullchain.pem" ]; then
    echo "Generating self-signed certificate for $DOMAIN ..."

    openssl req -x509 -nodes -newkey rsa:4096 \
        -keyout "$SSL_DIR/privkey.pem" \
        -out "$SSL_DIR/fullchain.pem" \
        -days 3650 \
        -subj "/CN=$DOMAIN" \
        -addext "subjectAltName=DNS:$DOMAIN" \
        -addext "keyUsage=digitalSignature,keyEncipherment" \
        -addext "extendedKeyUsage=serverAuth"

    echo "Certificate generated."
else
    echo "Certificate already exists – skipping generation."
fi

envsubst '${DOMAIN}' < /etc/nginx/templates/default.conf.template \
    > /etc/nginx/conf.d/default.conf

exec "$@"