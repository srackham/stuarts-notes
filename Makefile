# Makefile to log workflow.

# Set defaults (see http://clarkgrubb.com/makefile-style-guide#prologue)
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := test
.DELETE_ON_ERROR:
.SUFFIXES:
.ONESHELL:

.PHONY: build
build:
	hindsite build .

.PHONY: clean
clean:
	hindsite build .

.PHONY: serve
serve: build
	hindsite serve .

.PHONY: watch
watch:
	watch-hindsite.sh .

.PHONY: validate
validate: build
	for f in $$(find ./build -name "*.html"); do echo $$f; html-validator --verbose --format=text --file=$$f; done