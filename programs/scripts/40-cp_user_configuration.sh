#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

if [[ ${EUID} -eq 0 ]]; then
  log 'ERROR  This script MUST NOT run with superuser privileges' >&2
  exit 1
fi

RUNTIME_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")/../..")
readonly RUNTIME_DIR

cp "${@:-'--no-clobber'}" --recursive     \
  "${RUNTIME_DIR}config/"{.config,.local} \
  "${HOME}"
