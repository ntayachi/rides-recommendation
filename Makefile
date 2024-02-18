.PHONY: venv clean
.ONESHELL:
SHELL := /bin/bash

WORKDIR?=.
VENVDIR?=$(WORKDIR)/.venv
VENV=$(VENVDIR)/bin

venv:
	python3 -m venv $(VENVDIR)
	. $(VENV)/activate
	$(VENV)/pip install -r src/requirements.txt

clean:
	rm -rf $(VENVDIR)

