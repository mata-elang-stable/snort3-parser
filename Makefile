SHELL:=bash
GOCMD=go
GOTEST=$(GOCMD) test
GOVET=$(GOCMD) vet
BINARY_NAME=me-snort-parser
VERSION?=1.1
TARGET_PLATFORMS=linux/386 linux/arm linux/amd64 linux/arm64
DOCKER_REPO_URL=mataelang/snort3-parser

comma:= ,
empty:=
space:= $(empty) $(empty)
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

build: go-tidy build-linux ## Build the project and put the output binary in out/bin/

build-linux:
	@$(foreach platform, $(TARGET_PLATFORMS), \
		echo "[INFO] Compiling for $(platform)"; \
		GOOS=$(word 1,$(subst /, ,$(platform))) GOARCH=$(word 2,$(subst /, ,$(platform))) GO111MODULE=on CGO_ENABLED=0 $(GOCMD) build -o out/bin/$(BINARY_NAME)-$(word 1,$(subst /, ,$(platform)))-$(word 2,$(subst /, ,$(platform))) ./cmd/ ;\
	)
	
build-docker-multiarch: ## Build Docker Image then push to Docker Hub repository
	@echo "[INFO] Building docker image for platform: $(TARGET_PLATFORMS)"
	@docker buildx build --platform $(subst $(space),$(comma),$(TARGET_PLATFORMS)) -t $(DOCKER_REPO_URL):latest -t $(DOCKER_REPO_URL):$(VERSION) --push .

build-docker-image: ## Build Docker Image locally
	@echo "[INFO] Building docker image"
	@echo "[INFO] Docker image name: snort3-parser"
	@docker build -t snort3-parser .

clean: ## Remove build related file
	@rm -rf ./bin
	@rm -rf ./out
	@echo "[INFO] Any build output removed."

vendor: ## Copy of all packages needed to support builds in the vendor directory
	@ $(GOCMD) mod vendor

go-tidy:
	@$(GOCMD) mod tidy

run: ## Run with go run
	@go run main.go

help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
