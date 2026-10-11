#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_user

log_info 'Stopping potentially enabled gnome-keyring-daemon systemd-user-services'
systemctl --user disable --now gnome-keyring-daemon.s{ocket,ervice} 2>/dev/null
sudo systemctl --user disable --global gnome-keyring-daemon.s{ocket,ervice}
