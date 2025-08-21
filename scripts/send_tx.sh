#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

: "${BITCOIN_RPC_USER:=devuser}"
: "${BITCOIN_RPC_PASSWORD:=devpass}"
: "${TX_AMOUNT_BTC:=0.5}"

cli1() { docker exec btc-node1 bitcoin-cli -regtest -rpcuser="${BITCOIN_RPC_USER}" -rpcpassword="${BITCOIN_RPC_PASSWORD}" "$@"; }
cli2() { docker exec btc-node2 bitcoin-cli -regtest -rpcuser="${BITCOIN_RPC_USER}" -rpcpassword="${BITCOIN_RPC_PASSWORD}" "$@"; }

echo "Generating new receiver address on node2…"
RCV_ADDR=$(cli2 -rpcwallet=receiver getnewaddress "" bech32)
echo "Receiver address: ${RCV_ADDR}"

echo "Sending ${TX_AMOUNT_BTC} BTC from node1→node2…"
TXID=$(cli1 -rpcwallet=miner sendtoaddress "${RCV_ADDR}" "${TX_AMOUNT_BTC}")
echo "TXID: ${TXID}"

echo "Mining 1 block to confirm…"
MINER_ADDR=$(cli1 -rpcwallet=miner getnewaddress "" bech32)
cli1 generatetoaddress 1 "${MINER_ADDR}" >/dev/null

echo "Balances after tx:"
echo "node1 (miner): $(cli1 -rpcwallet=miner getbalance) BTC"
echo "node2 (receiver): $(cli2 -rpcwallet=receiver getbalance) BTC"
