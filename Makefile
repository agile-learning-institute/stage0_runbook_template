# Makefile for Stage0 Runbook Template
# Simple curl-based commands for testing runbooks
# 
# Customize this Makefile for your organization:
# 1. Update CONTAINER_IMAGE to your GHCR image name
# 2. Adjust API_URL if using a different port or host
# 3. Add any custom commands your team needs

.PHONY: help dev deploy down open validate execute get-token container tail

# Configuration - CUSTOMIZE THESE FOR YOUR ORG
CONTAINER_IMAGE ?= ghcr.io/YOUR_ORG/YOUR_RUNBOOKS_IMAGE:latest
API_URL ?= http://localhost:8083
RUNBOOK ?= 
DATA ?= {"env_vars":{}}

help:
	@echo "Available commands:"
	@echo "  make container        - Build container with your runbooks"
	@echo "  make dev              - Run your runbook in Dev mode (Mounts ./runbooks)"
	@echo "  make deploy           - Run your runbook in Deploy mode (Packaged Runbooks)"
	@echo "  make down             - Shut down containers"
	@echo "  make open             - Open web UI in browser"
	@echo "  make tail             - Tail API logs (captures terminal, Ctrl+C to exit)"
	@echo "  make validate         - Validate a runbook (requires RUNBOOK=path/to/runbook.md)"
	@echo "  make execute          - Execute a runbook (requires RUNBOOK=path/to/runbook.md)"
	@echo ""
	@echo "Examples:"
	@echo "  make container && make dev"
	@echo "  make validate RUNBOOK=./runbooks/MyRunbook.md"
	@echo "  make execute RUNBOOK=./runbooks/MyRunbook.md DATA='{\"env_vars\":{\"VAR1\":\"value1\"}}'"
	@echo "  make deploy"

container:
	@echo "Building container image: $(CONTAINER_IMAGE)"
	@docker build -f Dockerfile -t $(CONTAINER_IMAGE) .
	@echo "Built: $(CONTAINER_IMAGE)"

dev:
	@$(MAKE) down || true
	@docker-compose --profile runbook-dev up -d
	@$(MAKE) open

deploy:
	@$(MAKE) down || true
	@docker-compose --profile runbook-deploy up -d
	@$(MAKE) open
	
down:
	@docker-compose --profile runbook-dev --profile runbook-deploy down

open:
	@echo "Opening web UI..."
	@open http://localhost:8084 2>/dev/null || xdg-open http://localhost:8084 2>/dev/null || echo "Please open http://localhost:8084 in your browser"

get-token:
	@curl -s -X POST $(API_URL)/dev-login \
		-H "Content-Type: application/json" \
		-d '{"subject": "dev-user", "roles": ["developer", "admin"]}' \
		| jq -r '.access_token // .token // empty'

validate:
	@FILENAME=$$(basename $(RUNBOOK)); \
	TOKEN=$$(make -s get-token); \
	curl -s -X PATCH "$(API_URL)/api/runbooks/$$FILENAME/validate" \
		-H "Authorization: Bearer $$TOKEN" \
		-H "Content-Type: application/json" \
		-d '$(DATA)' \
		| jq '.' || cat

execute:
	@FILENAME=$$(basename $(RUNBOOK)); \
	TOKEN=$$(make -s get-token); \
	curl -s -X POST "$(API_URL)/api/runbooks/$$FILENAME/execute" \
		-H "Authorization: Bearer $$TOKEN" \
		-H "Content-Type: application/json" \
		-d '$(DATA)' \
		| jq '.' || cat

tail:
	@docker logs -f stage0_runbook_api
