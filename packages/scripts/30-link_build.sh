#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

if [[ ${EUID} -ne 0 ]]; then
  log 'This script needs to run WITH superuser privileges' >&2
  exit 1
fi

RUNTIME_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")/..")
OUT_DIR=${RUNTIME_DIR}/out

while read -r FILE; do
  LINK_NAME=/usr/local/${FILE#"${OUT_DIR}/"}
  mkdir -p "$(dirname "${LINK_NAME}")"
  ln --symbolic --force "${FILE}" "${LINK_NAME}"
done < <(command find "${OUT_DIR}/"{bin,etc,lib/udev,libexec,man,share/{applications,bash-completion,dbus-1,glib-2.0,icons,libinput,man,metainfo,rofi,wayland*}} -type f)
