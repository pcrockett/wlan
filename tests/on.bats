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

@test "on -- always -- turns radios on" {
    run with_nmcli_mock ./wlan on
    assert_output "nmcli args: radio wifi on"
    assert_success
}
