# hadolint ignore=DL3007
FROM docker.io/library/archlinux:latest

RUN pacman-key --init
# hadolint ignore=DL3059
RUN pacman --sync --refresh --sysupgrade --noconfirm \
    fzf make shellcheck bash-bats bash-bats-assert bash-bats-support && \
pacman --sync --clean --clean --noconfirm

WORKDIR /src

CMD [ "/usr/sbin/bash" ]
