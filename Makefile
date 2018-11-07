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
		case "$$f" in
		./docs/search.html|./docs/googlea9bb977b3a5379b9.html)
			# Skip pages that legitimately fail HTML validation.
			;;
		*)
			echo $$f
			html-validator --verbose --format=text --file=$$f
		;;
		esac
	done

.PHONY: push
push:
	git push -u --tags origin master
