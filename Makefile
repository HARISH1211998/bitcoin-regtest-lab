.PHONY: up send down logs n1 n2

up:
	./scripts/up.sh

send:
	./scripts/send_tx.sh

down:
	./scripts/down.sh

logs:
	docker compose logs -f

n1:
	docker exec -it btc-node1 bash

n2:
	docker exec -it btc-node2 bash
