#!/usr/bin/env bash
set -e

if [ -f ".env" ]; then
    echo "[INFO] Loading environment variables from .env"
    export $(grep -v '^#' .env | xargs)
else
    echo "[ERROR] .env file not found!"
    exit 1
fi

: "${DOMAIN:?DOMAIN is not set in .env}"
: "${POSTGRES_HOST:?POSTGRES_HOST is not set in .env}"
: "${POSTGRES_USER:?POSTGRES_USER is not set in .env}"
: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD is not set in .env}"
: "${POSTGRES_DB:?POSTGRES_DB is not set in .env}"

echo "[INFO] Environment variables loaded"

SYNAPSE_DIR="$(pwd)/data/synapse"
mkdir -p "$SYNAPSE_DIR"

HOMESERVER_YAML="$SYNAPSE_DIR/homeserver.yaml"

if [ ! -f "$HOMESERVER_YAML" ]; then
    echo "[INFO] Generating Synapse config..."

    docker run -it --rm \
        -v "$SYNAPSE_DIR:/data" \
        -e SYNAPSE_SERVER_NAME="$DOMAIN" \
        -e SYNAPSE_REPORT_STATS="yes" \
        matrixdotorg/synapse:latest generate

    echo "[INFO] Base Synapse config generated"

    echo "[INFO] Replacing SQLite with Postgres in homeserver.yaml"

    TMP_YAML="$SYNAPSE_DIR/homeserver_tmp.yaml"

    awk -v user="$POSTGRES_USER" -v pass="$POSTGRES_PASSWORD" -v db="$POSTGRES_DB" -v host="$POSTGRES_HOST" '
    BEGIN { in_db=0; skip=0 }
    /^database:/ {
        print "database:"
        print "  name: psycopg2"
        print "  args:"
        print "    user: " user
        print "    password: " pass
        print "    database: " db
        print "    host: " host
        print "    port: 5432"
        print "    cp_min: 5"
        print "    cp_max: 10"
        in_db=1
        next
    }
    /^  name: sqlite3/ { skip=1; next }
    skip && /^  args:/ { next }
    skip && /^    / { next }
    skip && !/^    / { skip=0; next }
    !skip && !/^  name: sqlite3/ { print }
    ' "$HOMESERVER_YAML" > "$TMP_YAML"

    mv "$TMP_YAML" "$HOMESERVER_YAML"

    chown 991:991 $HOMESERVER_YAML

    echo "[INFO] Replace SQLite with Postgres completed."
else
    echo "[INFO] Synapse config already exists — skipping generation"
fi

echo "[INFO] Building Docker images..."
docker compose build --no-cache

echo "[INFO] Starting Docker Compose services..."
docker compose up -d

echo "[INFO] Completed."
docker compose logs -f