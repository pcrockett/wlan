#!/usr/bin/env bats

setup() {
    set -Eeuo pipefail
    load '/usr/lib/bats-support/load.bash'
    load '/usr/lib/bats-assert/load.bash'
}

nmcli_mock() {
    if echo "${*}" | grep --fixed-strings "device wifi list" &> /dev/null; then
        echo -e -n "BSSID              SSID                              BARS  IN-USE 
\033[32m01:23:45:67:89:0A\033[0m  \033[32mgooberschnit\033[0m                      \033[32m▂▄▆█\033[0m  \033[32m \033[0m      
\033[33mBC:DE:F0:12:34:56\033[0m  \033[33mfooberdinkel\033[0m                      \033[33m▂▄▆_\033[0m  \033[33m \033[0m      
"
        return 0
    elif echo "${*}" | grep --fixed-strings "device status" &> /dev/null; then
        echo "wlp2s0:wifi:connected:fooberdinkel
tailscale0:tun:connected (externally):tailscale0
lo:loopback:unmanaged:"
        return 0
    elif echo "${*}" | grep --fixed-strings "device wifi connect" &> /dev/null; then
        echo "nmcli args: ${*}"
        return 0
    else
        echo "Boo, improperly configured mock!"
        return 1
    fi
}

fzf_mock() {
    cat > /dev/null
    if [ "${SHELL}" != "sh" ]; then
        echo "Wrong shell: ${SHELL}" 1>&2
        return 1
    fi
    echo "01:23:45:67:89:0A gooberschnit ▂▄▆█ "
}

cancelled_fzf_mock() {
    cat > /dev/null
    return 130
}

with_nmcli_mock() {
    export -f nmcli_mock
    WLAN_NMCLI=nmcli_mock "${@}"
}

with_fzf_mock() {
    export -f fzf_mock
    export -f nmcli_mock
    WLAN_NMCLI=nmcli_mock \
        WLAN_FZF=fzf_mock \
        "${@}"
}

with_cancelled_fzf_mock() {
    export -f cancelled_fzf_mock
    export -f nmcli_mock
    WLAN_NMCLI=nmcli_mock \
        WLAN_FZF=cancelled_fzf_mock \
        "${@}"
}

@test "connect -- query returns single bssid -- connects" {
    run with_nmcli_mock ./wlan -- gooberschnit
    assert_output "Connecting to BSSID 01:23:45:67:89:0A...
nmcli args: device wifi connect 01:23:45:67:89:0A"
    assert_success

    run with_nmcli_mock ./wlan -- BC:DE:F0:12:34:56
    assert_output "Connecting to BSSID BC:DE:F0:12:34:56...
nmcli args: device wifi connect BC:DE:F0:12:34:56"
    assert_success
}

@test "connect -- query returns nothing -- fails" {
    run with_nmcli_mock ./wlan -- zzzzzzzz
    assert_output ""
    assert_failure
}

@test "connect -- user cancels fzf -- fails" {
    run with_cancelled_fzf_mock ./wlan
    assert_output ""
    assert_failure
}

@test "connect -- user interactively selects a network -- connects" {
    run with_fzf_mock ./wlan
    assert_output "Connecting to BSSID 01:23:45:67:89:0A...
nmcli args: device wifi connect 01:23:45:67:89:0A"
    assert_success
}
