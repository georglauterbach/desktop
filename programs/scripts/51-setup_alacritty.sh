#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_root

log_info 'Setting up Alacritty as the default x-terminal-emulator'
update-alternatives --install  \
  /usr/bin/x-terminal-emulator \
  x-terminal-emulator          \
  /usr/local/bin/alacritty 50
