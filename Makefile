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
	make build-sitemap

.PHONY: serve
serve:
	hindsite serve . -build docs -launch -navigate -drafts -v

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

# Upload website to Github and submit sitemap.txt to Google
.PHONY: push
push: build
	git push -u --tags origin master
	make submit-sitemap

# Build Google search engine site map (see https://support.google.com/webmasters/answer/183668)
.PHONY: build-sitemap
build-sitemap:
	cd docs
	(find ./posts/ -maxdepth 2 -name '*.html'; find . -maxdepth 1 -name '*.html') \
	| grep -v './google' \
	| sed -e 's/^\./https:\/\/srackham.github.io\/stuarts-notes/g' \
	> sitemap.txt

# Submit site map to Google (see https://developers.google.com/search/docs/advanced/sitemaps/build-sitemap#addsitemap)
.PHONY: submit-sitemap
submit-sitemap:
	curl https://www.google.com/ping?sitemap=https://srackham.github.io/stuarts-notes/sitemap.txt
