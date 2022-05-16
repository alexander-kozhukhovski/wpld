ARGS = $(filter-out $@,$(MAKECMDGOALS))
MAKEFLAGS += --silent

.PHONY: help
.DEFAULT_GOAL := help

# Environment
-include docker/.env
-include .env

# Commands
install-certs: ## Install certificates for the project
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Installing certificates for the project..."
	mkcert -install
	mkdir -p docker/traefik/certs
	mkcert -cert-file docker/traefik/certs/app.cert -key-file docker/traefik/certs/app.key "${HOST_NAME}"

install-wp: ## Start default WordPress Docker configuration
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Starting default WordPress..."
	docker-compose up -d

install-core: ## Install WordPress Core
	bash docker/scripts/sign.sh
	bash docker/scripts/core-install.sh https://${HOST_NAME} ${EMAIL}

# Docker commands
status: ## Show docker status
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Docker Status:"
	docker-compose ps

logs: ## Show docker logs
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Docker Logs:"
	docker-compose logs -f --tail=50 $(ARGS)

stop: ## Stop docker project
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Stopping the project..."
	docker-compose stop

stop-clean: ## Stop docker project, remove containers, volumes and network
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Stopping the project..."
	bash docker/scripts/message.sh info "Removing containers, volumes and network..."
	docker-compose down -v --remove-orphans

start: ## Start docker project
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Starting the project..."
	docker-compose start

restart: ## Restart docker project
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Restarting the project..."
	docker-compose restart

uninstall: ## Uninstall docker project
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Uninstalling everything..."
	docker-compose down -v --remove-orphans --rmi all
	rm -r app

rebuild: ## Rebuild docker project
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Rebuilding the project..."
	docker-compose up --build --force-recreate -d

wpcli: ## Run WP-CLI commands. Put wpcli parameters into $args, e.g. make wpcli args='plugin list --status="active"
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Running WP-CLI command:"
	docker-compose run --rm wpcli $(args)

composer: ## Run Composer commands
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Running composer command:"
	docker-compose run --rm composer $(ARGS)

# MySQL commands
mysql-backup: ## Backup MySQL Database
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Exporting MySQL Database:"
	bash docker/scripts/mysql-export.sh ${APP_NAME}-mysql ${DB_NAME} ${DB_ROOT_PASSWORD}

mysql-restore: ## Restore MySQL Database from file, e.g. make mysql-restore mysql-2021-04-02.sql.gz
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Importing MySQL Database:"
	bash docker/scripts/mysql-import.sh ${APP_NAME}-mysql ${DB_NAME} ${DB_ROOT_PASSWORD} $(ARGS)

# Help command
help: ## Generate command list
	bash docker/scripts/sign.sh
	bash docker/scripts/message.sh info "Usage: make [command] args..."
	echo ""
	bash docker/scripts/message.sh info "Available commands:"
	@awk -F ':|##' '/^[^\t]#?.+?:.*?##/ { printf "\033[36m%-25s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST)

%:
	@:
