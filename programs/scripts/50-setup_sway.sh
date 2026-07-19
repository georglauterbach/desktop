#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

readonly HOME_DIR=${1:-}

require_run_as_root

if [[ -z ${HOME_DIR} ]]; then
  log_error 'This script MUST be run with one argument - your HOME directory path' >&2
  exit 1
fi

if [[ ! -d ${HOME_DIR} ]]; then
  log_error "The provided path '${HOME_DIR}' does not denote a valid / existing directory"
  exit 1
fi

if [[ ${#} -gt 1 ]]; then
  log_error 'This script MUST NOT be run with more than one argument' >&2
  exit 1
fi

log_info 'Linking SwayFX startup script into /usr/local/'

mkdir --parents /usr/local/bin
ln --symbolic --force "${HOME_DIR}/.local/bin/__sway" /usr/local/bin/__sway

log_info 'Writing custom desktop file for SwayFX'
mkdir --parents /usr/share/wayland-sessions
cat >/usr/share/wayland-sessions/swayfx.desktop <<"EOF"
[Desktop Entry]
Name=SwayFX
Comment=This session logs you into SwayFX, a fork of Sway (an i3-compatible Wayland compositor)
Exec=/usr/local/bin/__sway
Type=Application
DesktopNames=sway;wlroots;swayfx
EOF
