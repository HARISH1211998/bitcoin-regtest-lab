# Bitcoin Regtest Lab (2 Nodes, Fully Automated)

This repo spins up a **private Bitcoin regtest** network with **two nodes**, pairs them, mines blocks, and sends a transaction — **fully automated** (no manual RPC typing). Works **locally** and in **GitHub Actions**.

## Features

- 2 Bitcoin Core nodes in Docker
- Regtest forced (`-regtest`), cookie RPC auth (no secrets committed)
- Node2 auto-connects to Node1
- Idempotent scripts: create wallets if missing
- Parameterized mining & transaction amounts
- CI workflow with `workflow_dispatch` inputs and environment separation (dev/prod)

---

## Quick Start (Local)

### 1) Clone & setup

```bash
git clone <your-repo-url> <working dif>
cp .env.example .env   
