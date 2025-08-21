#!/usr/bin/env bash
set -euo pipefail

echo "[*] New address on node2..."
ADDR=$(docker exec node2 bitcoin-cli -regtest \
  -rpcuser="$NODE2_RPC_USER" -rpcpassword="$NODE2_RPC_PASSWORD" -rpcport=18445 getnewaddress)

echo "[*] Sending 10 BTC from node1 -> $ADDR"
docker exec node1 bitcoin-cli -regtest \
  -rpcuser="$NODE1_RPC_USER" -rpcpassword="$NODE1_RPC_PASSWORD" -rpcport=18443 \
  sendtoaddress "$ADDR" 10

echo "[*] Mining 1 block on node1..."
ADDR=$(docker exec node1 bitcoin-cli -regtest -rpcuser="$NODE1_RPC_USER" -rpcpassword="$NODE1_RPC_PASSWORD" -rpcport=18443 getnewaddress)
docker exec node1 bitcoin-cli -regtest -rpcuser="$NODE1_RPC_USER" -rpcpassword="$NODE1_RPC_PASSWORD" -rpcport=18443 generatetoaddress 1 "$ADDR"

echo "[*] Node2 balance:"
docker exec node2 bitcoin-cli -regtest \
  -rpcuser="$NODE2_RPC_USER" -rpcpassword="$NODE2_RPC_PASSWORD" -rpcport=18445 getbalance
