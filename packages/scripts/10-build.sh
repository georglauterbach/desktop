#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

if [[ ${EUID} -eq 0 ]]; then
  log "This script needs to run WITHOUT superuser privileges" >&2
  exit 1
fi

log 'Running pre-build commands'

for COMMAND in patchelf file earthly; do
  if ! command -v "${COMMAND}" &>/dev/null; then
    log "Command '${COMMAND}' not found but required"
    exit 1
  fi
done

log 'Starting build'

RUNTIME_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")/..")

cd "${RUNTIME_DIR}"
docker compose up --build

log Finished
