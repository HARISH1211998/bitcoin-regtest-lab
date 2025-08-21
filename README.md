Bitcoin Regtest Lab

A Docker-based Bitcoin Regtest environment with automated CI/CD for testing, wallet creation, and transactions between two nodes.

Repository

GitHub: https://github.com/HARISH1211998/bitcoin-regtest-lab

Features

Two Bitcoin Core nodes running in Regtest mode

Automated bitcoin.conf configuration generation

Wallet creation and pre-mining of 101 blocks

Automated transaction tests between nodes

CI/CD via GitHub Actions

Fully configurable environment using secrets or workflow inputs

Directory Structure
bitcoin-regtest-lab/
├─ node1/
│  └─ bitcoin.conf           # Generated automatically
├─ node2/
│  └─ bitcoin.conf           # Generated automatically
├─ scripts/
│  ├─ generate-config.sh    # Generates bitcoin.conf
│  ├─ setup.sh              # Wallet setup and pre-mining
│  └─ transaction.sh        # Example transaction between nodes
├─ docker-compose.yml
└─ Makefile

Prerequisites

Docker

Docker Compose

Bash shell (Linux/macOS or WSL2 on Windows)

Ensure Docker is running and you have permissions to execute Docker commands.

Getting Started
1. Clone the repository
git clone https://github.com/HARISH1211998/bitcoin-regtest-lab.git
cd bitcoin-regtest-lab

2. Set environment variables

Create a .env file in the project root:

NODE1_RPC_USER=user1
NODE1_RPC_PASSWORD=pass1
NODE2_RPC_USER=user2
NODE2_RPC_PASSWORD=pass2

3. Build and start the containers
make up

4. Setup wallets and pre-mine blocks
make setup


This will:

Create wallets for node1 and node2

Pre-mine 101 blocks on node1

5. Run transaction tests
make tx


This will:

Generate a new address on node2

Send BTC from node1 to node2

Mine a block to confirm the transaction

Display node2 balance

6. View logs
make logs

7. Tear down environment
make down

Notes

The setup is idempotent: you can run the scripts multiple times to create new transactions.

CI/CD is implemented using GitHub Actions, automatically building the environment, running setup, and validating transactions.

Secrets and RPC credentials are configurable via .env or GitHub workflow inputs.
