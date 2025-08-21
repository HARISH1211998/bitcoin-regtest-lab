.PHONY: up down logs setup tx

up:
	docker compose up -d

down:
	docker compose down -v

logs:
	docker compose logs -f

setup:
	@echo "[*] Generating bitcoin.conf files..."
	@bash scripts/generate-config.sh
	@echo "[*] Running setup..."
	@bash scripts/setup.sh

tx:
	@echo "[*] Running transaction script..."
	@bash scripts/transaction.sh
