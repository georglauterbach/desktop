#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_user

log_info 'Copying user configuration files'
cp "${@:---update=none}" --recursive                                 \
  "$(realpath -eL "${BASE_DIR}/..")/data/home/"{.config,.local,.var} \
  "${HOME}"
