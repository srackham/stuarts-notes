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
	hindsite build . -build docs

.PHONY: serve
serve:
	hindsite serve . -build docs -launch -v

.PHONY: validate
validate: build
	for f in $$(find ./docs -name "*.html"); do
		# Skip page (it has custom Google CSE elements that fail validation).
		if [ "$$f" != "./docs/search.html" ]; then
			echo $$f
			html-validator --verbose --format=text --file=$$f
		fi	
	done

.PHONY: push
push:
	git push -u --tags origin master
