ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CORE_DOCKERFILE:=$(ROOT_DIR)/docker-compose.core.yaml
HOMELAB_DOCKERFILE:=$(ROOT_DIR)/docker-compose.apps.yaml
CORE_COMPOSE_ARGS:=docker compose --file "$(CORE_DOCKERFILE)" --project-directory "$(ROOT_DIR)"
HOMELAB_COMPOSE_ARGS:=docker compose --file "$(HOMELAB_DOCKERFILE)" --project-directory "$(ROOT_DIR)"
SHELL:=/bin/bash

##@ Core 🧠

.PHONY: core-update
core-update: ## Update the core services*
	$(CORE_COMPOSE_ARGS) pull $(APP)
	$(CORE_COMPOSE_ARGS) up -d $(APP)

.PHONY: core-pull
core-pull: ## Pull the latest core services images*
	$(CORE_COMPOSE_ARGS) pull $(APP) $(ARGS)

.PHONY: core-up
core-up: ## Start the core services*
	$(CORE_COMPOSE_ARGS) up -d $(APP) $(ARGS)

.PHONY: core-down
core-down: ## Stop just the core services*
	$(CORE_COMPOSE_ARGS) down $(APP) $(ARGS)

.PHONY: core-stop
core-stop: ## Stop the core services*
	$(CORE_COMPOSE_ARGS) stop $(APP) $(ARGS)

.PHONY: core-logs
core-logs: ## Show the logs for the core services*
	$(CORE_COMPOSE_ARGS) logs -ft $(APP) $(ARGS)

.PHONY: core-restart
core-restart: ## Restart the core services*
	 $(CORE_COMPOSE_ARGS) restart  $(APP) $(ARGS)

.PHONY: core-ps
core-ps: ## Show the status of the core services
	$(CORE_COMPOSE_ARGS) ps --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Name}}"

.PHONY: core-config
core-config: ## Show the configuration of the core services*
	$(CORE_COMPOSE_ARGS) config $(APP) $(ARGS)

##@ Homelab 🐳

.PHONY: update
update: ## Update the service(s)*
	$(HOMELAB_COMPOSE_ARGS) pull $(APP)
	$(HOMELAB_COMPOSE_ARGS) up -d $(APP)

.PHONY: pull
pull: ## Pull the latest image(s)*
	$(HOMELAB_COMPOSE_ARGS) pull $(APP)

.PHONY: up
up: ## Start the service(s)*
	$(HOMELAB_COMPOSE_ARGS) up -d $(APP) $(ARGS)

.PHONY: down
down: ## Stop the service(s)*
	$(HOMELAB_COMPOSE_ARGS) down $(APP) $(ARGS)

.PHONY: stop
stop: ## Stop the service(s)*
	$(HOMELAB_COMPOSE_ARGS) stop $(APP) $(ARGS)

.PHONY: logs
logs: ## Show the logs*
	$(HOMELAB_COMPOSE_ARGS) logs $(APP) -ft $(ARGS)

.PHONY: restart
restart: ## Restart the service(s)*
	 $(HOMELAB_COMPOSE_ARGS) restart  $(APP) $(ARGS)

.PHONY: ps
ps: ## Show the status of the service(s)*
	$(HOMELAB_COMPOSE_ARGS) ps --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Name}}"

.PHONY: config
config: ## Show the configuration of the service(s)*
	$(HOMELAB_COMPOSE_ARGS) config $(APP) $(ARGS)

.PHONY: Misc Services 🧰

##@ Configuration 🪛

.PHONY: config-acme
config-acme: ## Initialize the acme.json file.
	mkdir -p appdata/traefik/acme/
	rm -f appdata/traefik/acme/acme.json
	touch appdata/traefik/acme/acme.json
	chmod 600 appdata/traefik/acme/acme.json

.PHONY: keygen
keygen: ## Generate an AGE decryption keypair for secrets management
	mise install
	mise run keygen

.PHONY: decrypt
decrypt: ## Decrypt the secrets files
	mise install
	mise run decrypt

.PHONY: encrypt
encrypt: ## Encrypt the secrets files
	mise install
	mise run encrypt


##@ Backup 🗂️

.PHONY: backup
backup: ## Backup the homelab repo to the ${BACKUP_DIR}.
	bash $(ROOT_DIR)/scripts/backup.sh $(ROOT_DIR)/appdata $(BACKUP_DIR)

.PHONY: backup-no-timestamp
backup-no-timestamp: ## Backup the homelab repo to the ${BACKUP_DIR} without a timestamp.
	bash $(ROOT_DIR)/scripts/backup.sh $(ROOT_DIR)/appdata $(BACKUP_DIR) --no-timestamp

##@ Development 🛠

.PHONY: docs
docs: ## Build the documentation.
	uv run mkdocs serve --livereload --dev-addr localhost:8000

.PHONY: lint
lint: ## Lint the code with pre-commit.
	pre-commit run --all-files

.PHONY: mise-install
mise-install: ## Helper target to install mise.
	curl -sSL https://mise.run | sh

##@ General 🌐

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
	@printf "\033[1;34mUsage:\033[0m \033[1;32mhomelab\033[0m \033[1;33m[target]\033[0m \033[1;36m(APP=service-name)\033[0m\n"
	@echo ""
	@printf "* pass \033[1;36mAPP=service-name\033[0m to specify the service\n"
	@printf "* pass \033[1;36mARGS=arguments\033[0m to specify additional arguments\n"
	@awk 'BEGIN {FS = ":.*##"; printf ""} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-19s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
