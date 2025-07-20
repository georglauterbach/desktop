#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

# shellcheck disable=SC2034
SCRIPT=desktop-setup LOG_LEVEL=${LOG_LEVEL:-info}

SCRIPT_DIR="$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR

# shellcheck source=/dev/null
source <(curl -qsSfL https://raw.githubusercontent.com/georglauterbach/libbash/main/load) \
  --online 8.1.0 log utils

source /etc/os-release || exit_failure_show_callstack 2 "Could not source '/etc/os-release'"

DIST_DIR=${SCRIPT_DIR}/distributions/ubuntu/${VERSION_ID}
readonly DIST_DIR

# Runs the part of the setup for which superuser privileges are required
function root_setup() {
  # shellcheck source=distributions/ubuntu/25.04/install.sh
  if ! source "${DIST_DIR}/install.sh"; then
    exit_failure_show_callstack 2 "Could not source install script for ${PRETTY_NAME}"
  fi

  log info 'Running root setup now'
  sudo bash -c "$(declare -f __root_setup) ; type __root_setup ;"
}

# Runs the user setup
function user_setup() {
  log info 'Running user setup now'
  while read -r FILE; do
    NEW_FILE=${HOME}/${FILE#"${DIST_DIR}/config/home/"}
    NEW_DIR=$(dirname "${NEW_FILE}")

    echo "Creating '${NEW_FILE}'"
    [[ -d ${NEW_DIR} ]] || mkdir -p "${NEW_DIR}"
    cp "${FILE}" "${NEW_FILE}"
  done < <(command find "${DIST_DIR}/config/home" -type f)
}

function main() {
  log info 'Starting desktop setup'

  root_setup
  user_setup

  log info 'Finished desktop setup'
}

main "${@}"
