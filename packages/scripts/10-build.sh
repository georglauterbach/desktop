#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

if [[ ${EUID} -eq 0 ]]; then
  log 'ERROR  This script needs to run WITHOUT superuser privileges' >&2
  exit 1
fi

if ! command -v docker &>/dev/null; then
  log "ERROR  The command 'docker' could not be found" >&2
  exit 1
fi

log 'Starting build'

RUNTIME_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")/..")

cd "${RUNTIME_DIR}"
docker compose up --build

log Finished
