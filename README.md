## wlan

Simple `nmcli` wrapper script to switch between wireless networks with just a few keystrokes.

### Usage

The script works with no arguments:

```bash
wlan
```

This will launch a fuzzy finder UI that allows you to quickly select a network and establish a connection.

If you are moving around, or your list of networks just happens to be omitting an SSID you know should be there:

```bash
wlan --rescan
```

To disconnect from a network:

```bash
wlan disconnect
# or for less typing:
wlan d
```

#### History

This script remembers your history, so you can navigate to previously-selected networks using key bindings:

* Previous history: `Ctrl-p` or `Ctrl-j`
* Next history: `Ctrl-n` or `Ctrl-k`

You can also set the initial network search query when invoking the command:

```bash
wlan -- My Network SSID
```

If "My Network SSID" only yields one (fuzzy) search result, the search UI won't even appear, and the connection will be
established without any further interaction. This enables you to use your terminal's history search function to
change networks even more quickly.

### Dependencies

* [fzf](https://github.com/junegunn/fzf)
* A Linux distro that uses [NetworkManager](https://wiki.archlinux.org/title/NetworkManager)

### Installation

```bash
sudo make install
```
