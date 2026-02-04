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

find "${OUT_DIR}" -type d -empty -delete

while read -r EXECUTABLE; do
  [[ $(file --mime-type --brief "${EXECUTABLE}") == *executable* ]] || continue
  patchelf --set-rpath "${OUT_DIR}/lib/x86_64-linux-gnu" "${EXECUTABLE}"
  patchelf --shrink-rpath                                "${EXECUTABLE}"
done < <(command find "${OUT_DIR}" -type f -executable)
unset EXECUTABLE

while read -r SHARED_OBJECT; do
  patchelf --set-rpath "${OUT_DIR}/lib/x86_64-linux-gnu" "${SHARED_OBJECT}"
  patchelf --shrink-rpath                                "${SHARED_OBJECT}"
done < <(command find "${OUT_DIR}/lib/" -type f -name '*.so*')
unset SHARED_OBJECT

patchelf --add-rpath "${OUT_DIR}/lib/stdc++" "${OUT_DIR}/bin/waybar"

log Finished
