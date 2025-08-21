#!/usr/bin/env bash
set -euo pipefail

CONTAINER=${1:?container name required}
RPCPORT=${2:?rpc port required}

until docker exec "$CONTAINER" bitcoin-cli -regtest \
  -rpcuser="$RPC_USER" -rpcpassword="$RPC_PASSWORD" -rpcport="$RPCPORT" getblockchaininfo >/dev/null 2>&1
do
  echo "Waiting for $CONTAINER (rpc:$RPCPORT)…"
  sleep 2
done

echo "$CONTAINER is ready."
