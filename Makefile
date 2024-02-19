.PHONY: venv debug-venv run build clean
.ONESHELL:
SHELL := /bin/bash

WORKDIR?=.
VENVDIR?=$(WORKDIR)/.venv
VENV=$(VENVDIR)/bin
TOUCHFILE=$(VENVDIR)/created-by-Makefile
REQUIREMENTS_TXT=$(WORKDIR)/app/requirements.txt
IMAGE?=rides-rec

venv: $(TOUCHFILE) ## Create a virtual environment

$(TOUCHFILE): $(REQUIREMENTS_TXT)
	@echo "Create a virtual environment ..."
	python3 -m venv $(VENVDIR)
	. $(VENV)/activate
	$(VENV)/pip install -r $(REQUIREMENTS_TXT)
	touch $(VENVDIR)/created-by-Makefile

debug-venv: venv ## Print the virtual environment directory, python and pip versions
	$(info SHELL="$(SHELL)")
	@echo VENVDIR: $(VENVDIR)
	@echo PYTHON VERSION: `python --version`
	@echo PIP VERSION: `pip --version`

debug: venv ## Run the Flask app in debug mode
	@echo "Run Flask app in debug mode ..."
	python -m app.app

build: ## Build the docker image
	@echo "Build docker image: $(IMAGE) ..."
	docker build -f docker/Dockerfile -t $(IMAGE) . --progress=plain

run: build ## Run inside a docker container
	@echo "Run inside docker contianer ..."
	docker run -p 5000:5000 \
	-e WEATHER_API_URL=$(WEATHER_API_URL) \
	-e WEATHER_API_KEY=$(WEATHER_API_KEY) \
	--cpu-shares=2 --cpus=1 \
	--memory=100m --memory-reservation=50m \
	$(IMAGE)

clean: ## Clean the virtual environment directory and *.pyc files
	rm -rf $(VENVDIR)
	find $(WORKDIR) -iname "*.pyc" -delete

help: ## Show this help message
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

