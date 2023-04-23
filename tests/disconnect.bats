#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
    set -Eeuo pipefail
    load '/usr/lib/bats-support/load.bash'
    load '/usr/lib/bats-assert/load.bash'
}

MOCK_DEVICE_STATUS=

nmcli_mock() {
    if echo "${*}" | grep --fixed-strings "device status" &> /dev/null; then
        echo "${MOCK_DEVICE_STATUS}"
        return 0
    elif echo "${*}" | grep --fixed-strings "device disconnect" &> /dev/null; then
        echo "nmcli args: ${*}"
        return 0
    else
        echo "Boo, improperly configured mock!"
        return 1
    fi
}

with_nmcli_mock() {
    MOCK_DEVICE_STATUS="wlp2s0:wifi:connected:fooberdinkel
tailscale0:tun:connected (externally):tailscale0
lo:loopback:unmanaged:"
    export MOCK_DEVICE_STATUS
    export -f nmcli_mock
    WLAN_NMCLI=nmcli_mock "${@}"
}

with_nmcli_mock_multi_wifi() {
    MOCK_DEVICE_STATUS="wlp2s0:wifi:connected:fooberdinkel
wlp2s1:wifi:connected:gooberschnit
wlp2s2:wifi:disconnected:
tailscale0:tun:connected (externally):tailscale0
lo:loopback:unmanaged:"
    export MOCK_DEVICE_STATUS
    export -f nmcli_mock
    WLAN_NMCLI=nmcli_mock "${@}"
}

with_nmcli_mock_disconnected() {
    MOCK_DEVICE_STATUS="wlp2s0:wifi:disconnected:
tailscale0:tun:connected (externally):tailscale0
lo:loopback:unmanaged:"
    export MOCK_DEVICE_STATUS
    export -f nmcli_mock
    WLAN_NMCLI=nmcli_mock "${@}"
}

@test "disconnect -- single wifi card connected -- disconnects" {
    EXPECTED="nmcli args: device disconnect wlp2s0"

    run with_nmcli_mock ./wlan disconnect
    assert_output "${EXPECTED}"
    assert_success

    run with_nmcli_mock ./wlan d
    assert_output "${EXPECTED}"
    assert_success

    run with_nmcli_mock ./wlan dis
    assert_output "${EXPECTED}"
    assert_success
}

@test "disconnect -- multiple wifi cards connected -- disconnects" {
    EXPECTED="nmcli args: device disconnect wlp2s0
nmcli args: device disconnect wlp2s1"

    run with_nmcli_mock_multi_wifi ./wlan disconnect
    assert_output "${EXPECTED}"
    assert_success

    run with_nmcli_mock_multi_wifi ./wlan d
    assert_output "${EXPECTED}"
    assert_success

    run with_nmcli_mock_multi_wifi ./wlan dis
    assert_output "${EXPECTED}"
    assert_success
}

@test "disconnect -- already disconnected -- does nothing" {
    run with_nmcli_mock_disconnected ./wlan disconnect
    assert_output ""
    assert_success
}
