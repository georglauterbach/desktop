#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

if [[ ${EUID} -ne 0 ]]; then
  log 'This script needs to run WITH superuser privileges' >&2
  exit 1
fi

update-alternatives --install  \
  /usr/bin/x-terminal-emulator \
  x-terminal-emulator          \
  /usr/local/bin/alacritty 50

mkdir --parents /usr/share/wayland-sessions
cat >/usr/share/wayland-sessions/sway.desktop <<"EOF"
[Desktop Entry]
Name=Sway
Comment=SwayFX built from source
Exec=/usr/local/bin/__sway
Type=Application
EOF
