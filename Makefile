#!make

all: build

.ONESHELL:
build:
	docker \
		build \
			--platform=linux/amd64 \
			-t mite-api-csv-import \
				.

.ONESHELL:
bundle-install:
	docker \
		run \
			--platform=linux/amd64 \
			--rm \
			-v "$(PWD)":/usr/src/app \
			-w /usr/src/app \
				ruby:3.2.2 \
					bundle install

.ONESHELL:
importer:
	docker \
		run \
			-it \
			--rm \
			--platform=linux/amd64 \
			--name mite-api-csv-import \
			-v "$(PWD)":/usr/src/app \
			-w /usr/src/app \
				mite-api-csv-import

.ONESHELL:
shell:
	docker \
		run \
			-it \
			--rm \
			--platform=linux/amd64 \
			--name mite-api-csv-import \
			-v "$(PWD)":/usr/src/app \
			-w /usr/src/app \
			--entrypoint=/bin/bash \
				mite-api-csv-import