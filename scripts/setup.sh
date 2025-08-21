#!/usr/bin/env bash
set -euo pipefail

# Verify required environment variables
: "${NODE1_RPC_USER:?Need to set NODE1_RPC_USER}"
: "${NODE1_RPC_PASSWORD:?Need to set NODE1_RPC_PASSWORD}"
: "${NODE2_RPC_USER:?Need to set NODE2_RPC_USER}"
: "${NODE2_RPC_PASSWORD:?Need to set NODE2_RPC_PASSWORD}"

echo "[*] Creating wallet on node1..."
docker exec node1 bitcoin-cli -regtest \
  -rpcuser="$NODE1_RPC_USER" -rpcpassword="$NODE1_RPC_PASSWORD" -rpcport=18443 \
  createwallet "wallet1" >/dev/null 2>&1 || echo "[*] Wallet1 already exists"

echo "[*] Creating wallet on node2..."
docker exec node2 bitcoin-cli -regtest \
  -rpcuser="$NODE2_RPC_USER" -rpcpassword="$NODE2_RPC_PASSWORD" -rpcport=18445 \
  createwallet "wallet2" >/dev/null 2>&1 || echo "[*] Wallet2 already exists"

echo "[*] Pre-mining 101 blocks on node1..."
ADDR=$(docker exec node1 bitcoin-cli -regtest \
  -rpcuser="$NODE1_RPC_USER" -rpcpassword="$NODE1_RPC_PASSWORD" -rpcport=18443 \
  getnewaddress)

docker exec node1 bitcoin-cli -regtest \
  -rpcuser="$NODE1_RPC_USER" -rpcpassword="$NODE1_RPC_PASSWORD" -rpcport=18443 \
  generatetoaddress 101 "$ADDR" >/dev/null

echo "[*] Setup complete!"
