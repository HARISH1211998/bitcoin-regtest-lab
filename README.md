# Bitcoin Regtest (2 nodes) with Docker + Bash

This project launches a private Bitcoin **regtest** network with **2 nodes**, pairs them, mines blocks, and sends at least one transaction from node1 → node2.

## Quick start

```bash
cp .env.example .env   # set your local values
make up                # start nodes, pair, mine, send first tx
make send              # send another tx (new tx each time)
make down              # stop and clean
