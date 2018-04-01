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
	hindsite build . -v

.PHONY: clean
clean:
	hindsite build . -v -clean

.PHONY: serve
serve: build
	hindsite serve . -v

.PHONY: watch
watch:
	(find ./content && find ./template) | entr hindsite build .