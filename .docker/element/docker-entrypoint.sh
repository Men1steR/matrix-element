#!/bin/sh
set -e

if [ -z "$DOMAIN" ]; then
    echo "ERROR: DOMAIN environment variable is not set!"
    exit 1
fi

if [ -z "$SERVER_NAME" ]; then
    echo "ERROR: SERVER_NAME environment variable is not set!"
    exit 1
fi


echo "DOMAIN = $DOMAIN"
echo "SERVER_NAME = $SERVER_NAME"

if [ ! -f /app/config.json.template ]; then
    echo "ERROR: Template /app/config.json.template not found!"
    exit 1
fi

echo "Generating /app/config.json from template..."

chmod 777 /app/config.json

envsubst '${DOMAIN} ${SERVER_NAME}' \
    < /app/config.json.template \
    > /app/config.json

echo "Generated config.json:"
cat /app/config.json

exec nginx -g "daemon off;"
