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

@test "help -- no commands given -- prints general usage" {
    EXPECTED="
Connect to wireless networks with minimal keystrokes.

Usage:
    wlan [command] [options]"

    run first_lines 5 \
        ./wlan --help
    assert_output "${EXPECTED}"
    assert_success

    run first_lines 5 \
        ./wlan -h
    assert_output "${EXPECTED}"
    assert_success
}

@test "help -- invalid command -- fails with usage" {
    EXPECTED="Unrecognized argument: \"foobar\"

Connect to wireless networks with minimal keystrokes.

Usage:
    wlan [command] [options]"

    run first_lines 6 \
        ./wlan foobar
    assert_output "${EXPECTED}"
    assert_failure
}

@test "help -- invalid option (no command) -- fails with usage" {
    EXPECTED="Unrecognized argument: \"--foobar\"

Connect to wireless networks with minimal keystrokes.

Usage:
    wlan [command] [options]"

    run first_lines 6 \
        ./wlan --foobar
    assert_output "${EXPECTED}"
    assert_failure
}

@test "help -- multiple commands -- treats second command as invalid arg" {
    EXPECTED="Unrecognized argument: \"disconnect\"

Connect to a wireless network.

Usage:
    wlan connect [options] [-- initial query]"

    run first_lines 6 \
        ./wlan connect disconnect
    assert_output "${EXPECTED}"
    assert_failure
}

@test "help -- connect command -- shows connect usage" {
    EXPECTED="
Connect to a wireless network.

Usage:
    wlan connect [options] [-- initial query]"

    run first_lines 5 \
        ./wlan connect --help
    assert_output "${EXPECTED}"
    assert_success
}

@test "help -- disconnect command -- shows disconnect usage" {
    EXPECTED="
Disconnect from a wireless network.

Usage:
    wlan disconnect"

    run first_lines 5 \
        ./wlan disconnect --help
    assert_output "${EXPECTED}"
    assert_success
}

@test "help -- off command -- shows off usage" {
    EXPECTED="
Turn your wireless radio off.

Usage:
    wlan off"

    run first_lines 5 \
        ./wlan off --help
    assert_output "${EXPECTED}"
    assert_success
}

@test "help -- on command -- shows on usage" {
    EXPECTED="
Turn your wireless radio on.

Usage:
    wlan on"

    run first_lines 5 \
        ./wlan on --help
    assert_output "${EXPECTED}"
    assert_success
}
