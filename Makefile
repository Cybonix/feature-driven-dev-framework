.PHONY: help list setup test lint build start

help: ## Show this help message
	@echo "Feature-Driven Development Framework - Developer Console"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

list: ## List all available tasks configured in ops/config.yml
	@bash scripts/run-task.sh --list

setup: ## Run project setup/install dependencies
	@bash scripts/run-task.sh setup

test: ## Run tests
	@bash scripts/run-task.sh test

lint: ## Run linter
	@bash scripts/run-task.sh lint

build: ## Build the project
	@bash scripts/run-task.sh build

start: ## Start the development server
	@bash scripts/run-task.sh start

# Catch-all for any other target to pass through to run-task.sh
%:
	@bash scripts/run-task.sh $@
