#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

# shellcheck disable=SC2034
SCRIPT=desktop-setup LOG_LEVEL=info

SCRIPT_DIR="$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR

# shellcheck source=/dev/null
source <(curl -qsSfL https://raw.githubusercontent.com/georglauterbach/libbash/main/load) \
  --online 8.1.0 log utils

source /etc/os-release || exit_failure_show_callstack 2 "Could not source '/etc/os-release'"

# Runs the part of the setup for which superuser privileges are required
function root_setup() {
  # shellcheck source=distributions/ubuntu/25.04/install.sh
  if ! source "${SCRIPT_DIR}/distributions/ubuntu/${VERSION_ID}/install.sh"; then
    exit_failure_show_callstack 2 "Could not source install script for ${PRETTY_NAME}"
  fi

  log info 'Running root setup now'
  sudo bash -c "$(declare -f __root_setup) ; type __root_setup ;"
}

# Runs the user setup
function user_setup() {
  log info 'Running user setup now'
  cp -r "${SCRIPT_DIR}/gui/home/"* "${HOME}"
}

function main() {
  log info 'Starting desktop setup'

  root_setup
  user_setup

  log info 'Finished desktop setup'
}

main "${@}"
