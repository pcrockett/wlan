#!/usr/bin/env bats

setup() {
    set -Eeuo pipefail
    load '/usr/lib/bats-support/load.bash'
    load '/usr/lib/bats-assert/load.bash'
}

nmcli_mock() {
    echo "nmcli args: ${*}"
}

with_nmcli_mock() {
    export -f nmcli_mock
    WLAN_NMCLI=nmcli_mock "${@}"
}

@test "off -- always -- turns radios off" {
    run with_nmcli_mock ./wlan off
    assert_output "nmcli args: radio wifi off"
    assert_success
}
