lint:
	shellcheck wlan
.PHONY: lint

install:
	install wlan /usr/local/bin/
.PHONY: install
