lint:
	shellcheck wlan tests/*.bats
.PHONY: lint

test:
	bats tests
.PHONY: test

install:
	install wlan /usr/local/bin/
.PHONY: install

podman-build:
	podman build --pull --tag "wlan-dev" dev-env
.PHONY: podman-build

dev-env: podman-build
	podman run --rm --interactive --tty --volume "$(shell pwd):/src" wlan-dev:latest
.PHONY: dev-env

ci: podman-build
	podman run --rm --volume "$(shell pwd):/src" wlan-dev:latest /usr/sbin/make lint test
.PHONY: ci
