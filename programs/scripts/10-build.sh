#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -e "\033[1m${*}\033[0m"
}

if [[ ${EUID} -eq 0 ]]; then
  log 'ERROR  This script MUST NOT run with superuser privileges' >&2
  exit 1
fi

if ! command -v podman &>/dev/null; then
  log "ERROR  The command 'podman' could not be found" >&2
  exit 1
fi

cd "$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")/..")"
readonly IMAGE_TAG=localhost/desktop-builder:latest

log 'Starting build'
podman build --tag "${IMAGE_TAG}" --file Containerfile .

log 'Copying files'
mkdir -p out
podman run --rm --volume ./out:/out "${IMAGE_TAG}" \
  /bin/bash -c "cp --recursive /usr/local/* /out/"

log Finished
