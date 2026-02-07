#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

if [[ ${EUID} -eq 0 ]]; then
  log 'This script needs to run WITHOUT superuser privileges' >&2
  exit 1
fi

mkdir --parents /usr/local/bin
sudo ln --symbolic --force         \
  "${HOME}/.local/bin/__sway" \
  /usr/local/bin/__sway
