ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PYTHON:=$(ROOT_DIR)/.venv/bin/python
SHELL:=/bin/bash

##@ docker compose 🐳

.PHONY: update
update: ## Update the services.
	docker compose --project-directory "$(ROOT_DIR)" pull
	docker compose --project-directory "$(ROOT_DIR)" up -d

.PHONY: pull
pull: ## Pull the latest images.
	docker compose --project-directory "$(ROOT_DIR)" pull

.PHONY: up
up: ## Start the services.
	docker compose --project-directory "$(ROOT_DIR)" up -d

.PHONY: down
down: ## Stop the services.
	docker compose --project-directory "$(ROOT_DIR)" down

.PHONY: stop
stop: ## Stop the services.
	docker compose --project-directory "$(ROOT_DIR)" stop

.PHONY: logs
logs: ## Show the logs.
	docker compose --project-directory "$(ROOT_DIR)" logs -ft

.PHONY: restart
restart: ## Restart the services.
	docker compose --project-directory "$(ROOT_DIR)" restart

.PHONY: ps
ps: ## Show the status of the services.
	docker compose --project-directory "$(ROOT_DIR)" ps --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Name}}"

.PHONY: up-traefik
up-traefik: ## Start just the traefik services
	docker compose --project-directory "$(ROOT_DIR)" up -d traefik oauth socket-proxy duckdns

##@ Configuration 🪛

.PHONY: acme-init
acme-init: ## Initialize the acme.json file.
	mkdir -p appdata/traefik/traefik/acme/
	rm -f appdata/traefik/traefik/acme/acme.json
	touch appdata/traefik/traefik/acme/acme.json
	chmod 600 appdata/traefik/traefik/acme/acme.json

##@ Backup 🗂️

.PHONY: backup
backup: ## Backup the homelab repo to the ${BACKUP_DIR}.
	bash $(ROOT_DIR)/scripts/backup.sh $(ROOT_DIR)/appdata $(BACKUP_DIR)

.PHONY: backup-no-timestamp
backup-no-timestamp: ## Backup the homelab repo to the ${BACKUP_DIR} without a timestamp.
	bash $(ROOT_DIR)/scripts/backup.sh $(ROOT_DIR)/appdata $(BACKUP_DIR) --no-timestamp

##@ development 🛠

.PHONY: docs
docs: ## Build the documentation.
	hatch run docs:serve --livereload --dev-addr localhost:8000

.PHONY: lint
lint: ## Lint the code with pre-commit.
	pre-commit run --all-files

##@ general 🌐

.PHONY: version
version: ## Show the version of the project.
	@git fetch --unshallow 2>/dev/null || true
	@git fetch --tags 2>/dev/null || true
	@echo "homelab $$(git describe --tags --abbrev=0)"

################################################
# Auto-Generated Help:
# - "##@" denotes a target category
# - "##" denotes a specific target description
###############################################
.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help message and exit
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  homelab \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-19s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
