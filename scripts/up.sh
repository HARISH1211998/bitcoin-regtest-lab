#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

: "${BITCOIN_RPC_USER:=devuser}"
: "${BITCOIN_RPC_PASSWORD:=devpass}"
: "${TX_AMOUNT_BTC:=1.0}"

compose() { docker compose "$@"; }

log() { printf "\n\033[1;32m%s\033[0m\n" "$*"; }

cli1() {
  docker exec btc-node1 bitcoin-cli -regtest \
    -rpcuser="${BITCOIN_RPC_USER}" -rpcpassword="${BITCOIN_RPC_PASSWORD}" "$@"
}
cli2() {
  docker exec btc-node2 bitcoin-cli -regtest \
    -rpcuser="${BITCOIN_RPC_USER}" -rpcpassword="${BITCOIN_RPC_PASSWORD}" "$@"
}

wait_rpc() {
  local name=$1
  local tries=60
  until docker exec "$name" bitcoin-cli -regtest \
    -rpcuser="${BITCOIN_RPC_USER}" -rpcpassword="${BITCOIN_RPC_PASSWORD}" getblockchaininfo >/dev/null 2>&1; do
    ((tries--)) || { echo "RPC not ready for $name"; exit 1; }
    sleep 1
  done
}

log "Starting containers…"
compose up -d

log "Waiting for RPC…"
wait_rpc btc-node1
wait_rpc btc-node2

log "Pairing nodes via addnode…"
# add each as a peer of the other
cli1 addnode "btc-node2:19444" "add" || true
cli2 addnode "btc-node1:18444" "add" || true

log "Create wallets if missing…"
# node1: miner wallet
if ! cli1 -rpcwallet=miner getwalletinfo >/dev/null 2>&1; then
  cli1 createwallet "miner" true true "" false true
fi
# node2: receiver wallet
if ! cli2 -rpcwallet=receiver getwalletinfo >/dev/null 2>&1; then
  cli2 createwallet "receiver" true true "" false true
fi

log "Mine 101 blocks to mature coinbase on node1…"
MINER_ADDR=$(cli1 -rpcwallet=miner getnewaddress "" bech32)
cli1 generatetoaddress 101 "${MINER_ADDR}" >/dev/null

log "Generate fresh receiver address on node2…"
RCV_ADDR=$(cli2 -rpcwallet=receiver getnewaddress "" bech32)
echo "Receiver address: ${RCV_ADDR}"

log "Send ${TX_AMOUNT_BTC} BTC from node1→node2…"
TXID=$(cli1 -rpcwallet=miner sendtoaddress "${RCV_ADDR}" "${TX_AMOUNT_BTC}")
echo "TXID: ${TXID}"

log "Mine 1 block to confirm…"
cli1 generatetoaddress 1 "${MINER_ADDR}" >/dev/null

log "Balances:"
echo "node1 (miner): $(cli1 -rpcwallet=miner getbalance) BTC"
echo "node2 (receiver): $(cli2 -rpcwallet=receiver getbalance) BTC"

log "Done. You can run ./scripts/send_tx.sh to create another tx."
