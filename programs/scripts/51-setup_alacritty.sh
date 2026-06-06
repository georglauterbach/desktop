#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

if [[ ${EUID} -ne 0 ]]; then
  log 'ERROR  This script MUST run with superuser privileges' >&2
  exit 1
fi

update-alternatives --install  \
  /usr/bin/x-terminal-emulator \
  x-terminal-emulator          \
  /usr/local/bin/alacritty 50
