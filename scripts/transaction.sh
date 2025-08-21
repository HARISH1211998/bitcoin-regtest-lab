#!/usr/bin/env bash
set -euo pipefail

ADDR2=$(docker exec node2 bitcoin-cli -regtest -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD getnewaddress)
docker exec node1 bitcoin-cli -regtest -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD sendtoaddress $ADDR2 10

# Mine a block to confirm
ADDR1=$(docker exec node1 bitcoin-cli -regtest -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD getnewaddress)
docker exec node1 bitcoin-cli -regtest -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD generatetoaddress 1 $ADDR1

BALANCE=$(docker exec node2 bitcoin-cli -regtest -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD getbalance)
echo "[*] Node2 balance: $BALANCE BTC"
