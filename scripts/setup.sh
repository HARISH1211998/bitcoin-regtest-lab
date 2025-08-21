#!/usr/bin/env bash
set -euo pipefail

echo "[*] Creating wallet on node1..."
docker exec node1 bitcoin-cli -regtest \
  -rpcuser="$NODE1_RPC_USER" -rpcpassword="$NODE1_RPC_PASSWORD" -rpcport=18443 \
  createwallet "wallet1" || true

echo "[*] Creating wallet on node2..."
docker exec node2 bitcoin-cli -regtest \
  -rpcuser="$NODE2_RPC_USER" -rpcpassword="$NODE2_RPC_PASSWORD" -rpcport=18445 \
  createwallet "wallet2" || true

echo "[*] Pre-mining 101 blocks on node1..."
ADDR=$(docker exec node1 bitcoin-cli -regtest \
  -rpcuser="$NODE1_RPC_USER" -rpcpassword="$NODE1_RPC_PASSWORD" -rpcport=18443 getnewaddress)

docker exec node1 bitcoin-cli -regtest \
  -rpcuser="$NODE1_RPC_USER" -rpcpassword="$NODE1_RPC_PASSWORD" -rpcport=18443 \
  generatetoaddress 101 "$ADDR"

echo "[*] Setup complete!"
