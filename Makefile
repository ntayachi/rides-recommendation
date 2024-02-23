.PHONY: venv debug-venv run docker-build docker-run docker-clean clean
.DEFAULT_GOAL := help
.ONESHELL:
SHELL := /bin/bash

APP_ROOT?=.
VENVDIR?=$(APP_ROOT)/.venv
VENV=$(VENVDIR)/bin
TOUCHFILE=$(VENVDIR)/created-by-Makefile
REQUIREMENTS_TXT=$(APP_ROOT)/app/requirements.txt
IMAGE?=rides-rec

venv: $(TOUCHFILE) ## Create a virtual environment

$(TOUCHFILE): $(REQUIREMENTS_TXT)
	@echo "Create a virtual environment ..."
	python3 -m venv $(VENVDIR)
	. $(VENV)/activate
	$(VENV)/pip install -r $(REQUIREMENTS_TXT)
	touch $(TOUCHFILE)

venv-debug: venv ## Print the virtual environment directory, python and pip versions
	$(info SHELL="$(SHELL)")
	@echo VENVDIR: $(VENVDIR)
	@echo PYTHON VERSION: `$(VENV)/python --version`
	@echo PIP VERSION: `$(VENV)/pip --version`

run: venv ## Run the Flask app
	@echo "Run the Flask app ..."
	$(VENV)/python -m app.app

docker-build: ## Build the docker image
	@echo "Build docker image: $(IMAGE) ..."
	docker build -f docker/Dockerfile -t $(IMAGE) . --progress=plain

docker-run: docker-build ## Run inside a docker container
	@echo "Run inside docker contianer ..."
	docker run --publish 5000:5000 \
		--label image=$(IMAGE) \
		--env WEATHER_API_URL=$(WEATHER_API_URL) \
		--env WEATHER_API_KEY=$(WEATHER_API_KEY) \
		--cpu-shares=2 --cpus=1 \
		--memory=100m --memory-reservation=50m \
		$(IMAGE)

docker-clean: ## Remove old docker containers
	docker ps --all --quiet --filter label=image=$(IMAGE) | xargs docker rm

clean: ## Clean the virtual environment directory and *.pyc files
	rm -rf $(VENVDIR)
	find $(APP_ROOT) -iname "*.pyc" -delete

help: ## Show this help message
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

