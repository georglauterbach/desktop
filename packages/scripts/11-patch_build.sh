#! /usr/bin/env bash

# If there are issues with shared objects or the loader, use 'libtree'
# (apt-get install libtree) and run it with 'libtree -p -vvv <ELF>'

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
  patchelf --add-rpath       "${OUT_DIR}/lib/x86_64-linux-gnu"                      "${EXECUTABLE}"
  patchelf --set-interpreter "${OUT_DIR}/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2" "${EXECUTABLE}"
  patchelf --shrink-rpath    --allowed-rpath-prefixes "${OUT_DIR}"                  "${EXECUTABLE}"
done < <(command find "${OUT_DIR}" -type f -executable)
unset EXECUTABLE

while read -r SHARED_OBJECT; do
  [[ ${SHARED_OBJECT} == *ld-linux-x86-64.so.2 ]] && continue
  patchelf --add-rpath "${OUT_DIR}/lib/x86_64-linux-gnu"        "${SHARED_OBJECT}"
  patchelf --shrink-rpath --allowed-rpath-prefixes "${OUT_DIR}" "${SHARED_OBJECT}"
done < <(command find "${OUT_DIR}/lib/" -type f -name '*.so*')
unset SHARED_OBJECT

log Finished
