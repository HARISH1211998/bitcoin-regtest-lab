Here’s a full README.md template for your repo:

# Bitcoin Regtest Lab

A Docker-based Bitcoin Regtest environment with automated CI/CD for testing, wallet creation, and transactions between two nodes.

## Prerequisites

- Docker  
- Docker Compose  
- Bash shell (Linux/macOS or WSL2 on Windows)  

> Ensure Docker is running and you have permissions to execute Docker commands.

## Repository

GitHub: [https://github.com/HARISH1211998/bitcoin-regtest-lab](https://github.com/HARISH1211998/bitcoin-regtest-lab)

---

## Features

- Two Bitcoin Core nodes running in Regtest mode
- Automated configuration generation (`bitcoin.conf`)
- Wallet creation and pre-mining of 101 blocks
- Automated transaction tests between nodes
- CI/CD via GitHub Actions
- Full environment configurable with secrets or workflow inputs

---

## Directory Structure




bitcoin-regtest-lab/
├─ node1/
│ └─ bitcoin.conf # Generated automatically
├─ node2/
│ └─ bitcoin.conf # Generated automatically
├─ scripts/
│ ├─ generate-config.sh # Generates bitcoin.conf
│ ├─ setup.sh # Wallet setup and pre-mining
│ └─ transaction.sh # Example transaction between nodes
├─ docker-compose.yml
└─ Makefile


---
Notes
The setup is idempotent: you can run the scripts multiple times to create new transactions.
CI/CD is implemented using GitHub Actions, automatically building the environment, running setup, and validating transactions.
Secrets and RPC credentials are configurable via .env or GitHub workflow inputs.


## Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/HARISH1211998/bitcoin-regtest-lab.git
cd bitcoin-regtest-lab

2. Set environment variables

Create a .env file:

NODE1_RPC_USER=user1
NODE1_RPC_PASSWORD=pass1
NODE2_RPC_USER=user2
NODE2_RPC_PASSWORD=pass2

3. Build and run containers
make up

4. Setup wallets and pre-mine blocks
make setup

5. Run transaction tests
make tx

6. View logs
make logs

7. Tear down
make down
