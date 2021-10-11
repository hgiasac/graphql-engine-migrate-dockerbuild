#!/bin/bash

set -e

log() {
    TIMESTAMP=$(date -u "+%Y-%m-%d %H:%M:%S")
    MESSAGE=$1
    echo "$TIMESTAMP $MESSAGE"
}

if [ -z ${ENDPOINT+x} ]; then
  log "ENDPOINT env var is required"
  exit 1
fi

if [ -z ${HASURA_GRAPHQL_ADMIN_SECRET+x} ]; then
  log "HASURA_GRAPHQL_ADMIN_SECRET env var is required"
  exit 1
fi

if [ -z ${MIGRATIONS_TIMEOUT+x} ]; then
    log "MIGRATIONS_TIMEOUT is not set, defaulting to 30 seconds"
    MIGRATIONS_TIMEOUT=30
fi

http_wait() {
  for i in `seq 1 $MIGRATIONS_TIMEOUT`;
  do
    local code="$(curl -s -o /dev/null -m 2 -w '%{http_code}' $1)"
    if [ $code != "200" ]; then
      sleep 1
    else
      log "$1 is ready" && return
    fi
  done

  log "failed waiting for $1, try increasing MIGRATIONS_TIMEOUT (default: 30)" && exit 1
}

http_wait "$ENDPOINT/healthz"

# apply metadata
hasura metadata apply --admin-secret $HASURA_GRAPHQL_ADMIN_SECRET --endpoint $ENDPOINT

# apply migration
hasura migrate apply --all-databases --admin-secret $HASURA_GRAPHQL_ADMIN_SECRET --endpoint $ENDPOINT
hasura metadata reload --admin-secret $HASURA_GRAPHQL_ADMIN_SECRET --endpoint $ENDPOINT

