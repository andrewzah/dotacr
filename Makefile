.PHONY: build

build:
	crystal build src/dota.cr

release:
	crystal build src/dota.cr --release
