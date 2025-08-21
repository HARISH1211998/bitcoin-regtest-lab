#!/usr/bin/env bash
set -euo pipefail

echo "[*] Starting regtest network..."
docker-compose up -d

echo "[*] Waiting for nodes..."
./scripts/wait-for-node.sh node1
./scripts/wait-for-node.sh node2

# Connect node2 → node1
NODE1_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' node1)
docker exec node2 bitcoin-cli -regtest -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD addnode $NODE1_IP:18444 onetry

# Mine blocks
ADDR1=$(docker exec node1 bitcoin-cli -regtest -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD getnewaddress)
docker exec node1 bitcoin-cli -regtest -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD generatetoaddress 101 $ADDR1

echo "[*] Setup complete"
