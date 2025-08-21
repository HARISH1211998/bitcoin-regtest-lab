#!/usr/bin/env bash
set -euo pipefail

NODE=$1

until docker exec $NODE bitcoin-cli -regtest -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD getblockchaininfo >/dev/null 2>&1; do
  echo "Waiting for $NODE..."
  sleep 2
done

echo "$NODE is ready!"
