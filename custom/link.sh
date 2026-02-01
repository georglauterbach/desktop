#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

if [[ ${EUID} -ne 0 ]]; then
  echo 'Run this script as root' >&2
  exit 1
fi

OUT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")/out

while read -r FILE; do
  LINK_NAME=/usr/local/${FILE#"${OUT_DIR}/"}
  mkdir -p "$(dirname "${LINK_NAME}")"
  ln --symbolic --force "${FILE}" "${LINK_NAME}"
done < <(command find "${OUT_DIR}/"{bin,etc,lib/udev,libexec,man,share/{applications,bash-completion,dbus-1,glib-2.0,icons,libinput,man,rofi,wayland*}} -type f)
