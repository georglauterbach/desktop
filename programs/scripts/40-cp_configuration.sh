#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_user

log_info 'Copying user configuration files'
cp "${@:---update=older}" --recursive                                \
  "$(realpath -eL "${BASE_DIR}/..")/data/home/"{.config,.local,.var} \
  "${HOME}"

# Themes and icons are copied into ~/.local/share/ rather than linked into
# /usr/local so Flatpak apps can read them as well.
log_info 'Copying themes'
mkdir --parents "${HOME}/.local/share/themes"
cp "${@:---update=older}" --recursive "${OUT_DIR}/share/themes/." "${HOME}/.local/share/themes/"

log_info 'Reloading systemd user manager'
systemctl --user daemon-reload
