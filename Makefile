ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PYTHON:=$(ROOT_DIR)/.venv/bin/python
PROFILE:=all
SHELL:=/bin/bash

##@ Homelab 🐳

.PHONY: update
update: ## Update the service(s) *
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) pull $(APP)
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) up -d $(APP)

.PHONY: pull
pull: ## Pull the latest image(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) pull $(APP)

.PHONY: up
up: ## Start the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) up -d $(APP) $(ARGS)

.PHONY: down
down: ## Stop the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) down $(APP) $(ARGS)

.PHONY: stop
stop: ## Stop the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) stop $(APP) $(ARGS)

.PHONY: logs
logs: ## Show the logs*
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) logs $(APP) -ft $(ARGS)

.PHONY: restart
restart: ## Restart the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) restart  $(APP) $(ARGS)

.PHONY: ps
ps: ## Show the status of the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) ps --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Name}}"

.PHONY: config
config: ## Show the configuration of the service(s)*
	docker compose --project-directory "$(ROOT_DIR)" --profile $(PROFILE) config $(APP) $(ARGS)

##@ Core Services 🧠

.PHONY: core-up
core-up: ## Start just the core services (traefik, oauth2, etc).
	docker compose --project-directory "$(ROOT_DIR)" --profile core up -d

.PHONY: core-down
core-down: ## Stop just the core services (traefik, oauth2, etc).
	docker compose --project-directory "$(ROOT_DIR)" --profile core down

.PHONY: core-logs
core-logs: ## Show the logs for the core services (traefik, oauth2, etc).
	docker compose --project-directory "$(ROOT_DIR)" --profile core logs -ft

##@ Media Services 📺

.PHONY: media-up
media-up: ## Start just the media services (plex, sonarr, radarr, etc).
	docker compose --project-directory "$(ROOT_DIR)" --profile media up -d

.PHONY: media-down
media-down: ## Stop just the media services (plex, sonarr, radarr, etc).
	docker compose --project-directory "$(ROOT_DIR)" --profile media down

.PHONY: media-logs
media-logs: ## Show the logs for the media services (plex, sonarr, radarr, etc).
	docker compose --project-directory "$(ROOT_DIR)" --profile media logs -ft

.PHONY: Misc Services 🧰

##@ Configuration 🪛

.PHONY: config-acme
config-acme: ## Initialize the acme.json file.
	mkdir -p appdata/traefik/acme/
	rm -f appdata/traefik/acme/acme.json
	touch appdata/traefik/acme/acme.json
	chmod 600 appdata/traefik/acme/acme.json

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
	hatch run docs:serve --livereload --dev-addr localhost:8000

.PHONY: lint
lint: ## Lint the code with pre-commit.
	pre-commit run --all-files

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
