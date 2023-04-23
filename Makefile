lint:
	shellcheck wlan tests/*.bats
.PHONY: lint

test:
	bats tests
.PHONY: test

install:
	install wlan /usr/local/bin/
.PHONY: install
