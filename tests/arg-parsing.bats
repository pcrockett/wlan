#!/usr/bin/env bats

setup() {
    set -Eeuo pipefail
    load '/usr/lib/bats-support/load.bash'
    load '/usr/lib/bats-assert/load.bash'
}

first_lines() {
    # Run a command, only outputting the first N lines.
    #
    # Args:
    #
    # $1 is the number of lines you want to output
    # the rest is the command you want to run
    local line_count="${1}"
    shift
    "${@}" 2>&1 | head --lines "${line_count}"
}

@test "help -- always -- prints usage" {
    EXPECTED="Connect to wireless networks with minimal keystrokes.

Usage:
    wlan [command] [options] [-- initial query]"

    run first_lines 4 \
        ./wlan --help
    assert_output "${EXPECTED}"
    assert_success

    run first_lines 4 \
        ./wlan -h
    assert_output "${EXPECTED}"
    assert_success
}

@test "invalid command -- always -- fails with usage" {
    EXPECTED="Unrecognized argument: foobar

Usage:"

    run first_lines 3 \
        ./wlan foobar
    assert_output "${EXPECTED}"
    assert_failure
}

@test "invalid option -- always -- fails with usage" {
    EXPECTED="Unrecognized argument: --foobar

Usage:"

    run first_lines 3 \
        ./wlan connect --foobar
    assert_output "${EXPECTED}"
    assert_failure
}

@test "multiple commands -- always -- fails with usage" {
    EXPECTED="Conflicting commands: \"connect\" and \"disconnect\"

Usage:"

    run first_lines 3 \
        ./wlan connect disconnect
    assert_output "${EXPECTED}"
    assert_failure
}
