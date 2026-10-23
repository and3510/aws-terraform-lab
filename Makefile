# Uso: make <alvo> [ENV=dev]
ENV   ?= dev
DIR   := aws/environments/$(ENV)
TF    := terraform -chdir=$(DIR)

BACKEND_ARGS := $(if $(wildcard $(DIR)/backend.hcl),-backend-config=backend.hcl,)

.DEFAULT_GOAL := help
.PHONY: help init plan apply destroy output fmt fmt-check validate lint check bootstrap local-up local-down

help: ## Lista os alvos disponíveis
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

init: ## terraform init no ambiente (usa backend.hcl se existir)
	$(TF) init $(BACKEND_ARGS)

plan: ## Gera plano em tfplan
	$(TF) plan -out=tfplan

apply: ## Aplica o plano salvo (rode `make plan` antes)
	$(TF) apply tfplan

destroy: ## Destroi os recursos do ambiente
	$(TF) destroy

output: ## Mostra outputs do ambiente
	$(TF) output

fmt: ## Formata todo o código
	terraform fmt -recursive

fmt-check: ## Verifica formatação (CI)
	terraform fmt -recursive -check -diff

validate: ## Valida todos os root modules e módulos
	@for d in $$(find . -name '*.tf' -not -path '*/.terraform/*' -exec dirname {} \; | sort -u); do \
		echo "==> $$d"; \
		terraform -chdir=$$d init -backend=false -input=false >/dev/null && terraform -chdir=$$d validate || exit 1; \
	done

lint: ## Roda tflint recursivamente
	tflint --init
	tflint --recursive --config "$$(pwd)/.tflint.hcl"

check: fmt-check validate lint ## Todas as verificações estáticas

bootstrap: ## Cria o bucket S3 de remote state (state local)
	terraform -chdir=aws/bootstrap init
	terraform -chdir=aws/bootstrap apply

local-up: ## Sobe o LocalStack (AWS emulada) para ENV=local
	docker compose -f aws/environments/local/docker-compose.yml up -d --wait

local-down: ## Derruba o LocalStack (descarta tudo que foi simulado)
	docker compose -f aws/environments/local/docker-compose.yml down
