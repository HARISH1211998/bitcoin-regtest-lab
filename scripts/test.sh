#!/bin/bash
set -e

# Node1 RPC credentials
NODE1_RPC="http://user1:pass1@127.0.0.1:18443"

# Node2 RPC credentials
NODE2_RPC="http://user2:pass2@127.0.0.1:18445"

echo "⏳ Waiting 5s for nodes to start..."
sleep 5

echo "🔍 Checking Node1 blockchain info..."
curl -s --user user1:pass1 --data-binary '{"jsonrpc":"1.0","id":"curl","method":"getblockchaininfo","params":[]}' -H 'content-type:text/plain;' $NODE1_RPC | jq .

echo "🔍 Checking Node2 blockchain info..."
curl -s --user user2:pass2 --data-binary '{"jsonrpc":"1.0","id":"curl","method":"getblockchaininfo","params":[]}' -H 'content-type:text/plain;' $NODE2_RPC | jq .

echo "⚡ Generating 101 blocks on Node1..."
curl -s --user user1:pass1 --data-binary '{"jsonrpc":"1.0","id":"curl","method":"generatetoaddress","params":[101, "bcrt1qtestaddressxxxxxxxxxxxxxx"]}' -H 'content-type:text/plain;' $NODE1_RPC > /dev/null

echo "🔄 Checking Node2 block count (should match Node1)..."
NODE1_HEIGHT=$(curl -s --user user1:pass1 --data-binary '{"jsonrpc":"1.0","id":"curl","method":"getblockcount","params":[]}' -H 'content-type:text/plain;' $NODE1_RPC | jq '.result')
NODE2_HEIGHT=$(curl -s --user user2:pass2 --data-binary '{"jsonrpc":"1.0","id":"curl","method":"getblockcount","params":[]}' -H 'content-type:text/plain;' $NODE2_RPC | jq '.result')

echo "📊 Node1 height: $NODE1_HEIGHT"
echo "📊 Node2 height: $NODE2_HEIGHT"

if [ "$NODE1_HEIGHT" -eq "$NODE2_HEIGHT" ]; then
  echo "✅ Success! Node1 and Node2 are in sync 🎉"
else
  echo "❌ Nodes are NOT in sync!"
fi
