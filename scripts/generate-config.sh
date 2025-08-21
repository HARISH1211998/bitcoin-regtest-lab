#!/bin/bash
set -euo pipefail
export $(grep -v '^#' .env | xargs)

mkdir -p node1 node2

# Node1
cat > ./node1/bitcoin.conf <<EOF
[regtest]
regtest=1
server=1
rpcuser=${NODE1_RPC_USER}
rpcpassword=${NODE1_RPC_PASSWORD}
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
rpcport=18443
listen=1
port=18444
fallbackfee=0.0002
EOF

# Node2
cat > ./node2/bitcoin.conf <<EOF
[regtest]
regtest=1
server=1
rpcuser=${NODE2_RPC_USER}
rpcpassword=${NODE2_RPC_PASSWORD}
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
rpcport=18445
listen=1
port=18446
addnode=node1:18444
fallbackfee=0.0002
EOF

echo "[*] bitcoin.conf files generated."
