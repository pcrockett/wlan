## wlan

Stupid simple `nmcli` wrapper script to switch between wireless networks with just a few keystrokes.

### Usage

In the majority of cases, you probably don't need any arguments.

```bash
wlan
```

If you are moving around, or your list of networks just happens to be omitting an SSID you know should be there:

```bash
wlan --rescan
```

This script remembers your history, so you can navigate to previously-selected networks using key bindings:

* Previous history: `Ctrl-p` or `Ctrl-j`
* Next history: `Ctrl-n` or `Ctrl-k`

### Dependencies

* [fzf](https://github.com/junegunn/fzf)
* A Linux distro that uses [NetworkManager](https://wiki.archlinux.org/title/NetworkManager)

### Installation

```bash
sudo make install
```
