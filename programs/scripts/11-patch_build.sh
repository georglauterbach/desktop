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

if ! command -v lief-patchelf &>/dev/null; then
  log "ERROR  The command 'lief-patchelf' could not be found" >&2
  exit 1
fi

OUT_DIR="$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")/..")/out"
readonly OUT_DIR

log "Patching files in '${OUT_DIR}'\n"

find "${OUT_DIR}" -type d -empty -delete

# ! The order and the exact commands that we use to patch the shared
#   objects and executables is very important.

while read -r SHARED_OBJECT; do
  [[ ${SHARED_OBJECT} == *ld-linux-x86-64.so.2 ]] && continue
  lief-patchelf --remove-rpath                                "${SHARED_OBJECT}"
  lief-patchelf --set-rpath "${OUT_DIR}/lib/x86_64-linux-gnu" "${SHARED_OBJECT}"
  lief-patchelf --force-rpath                                 "${SHARED_OBJECT}"
done < <(command find "${OUT_DIR}/lib/" -type f -name '*.so*')
unset SHARED_OBJECT

while read -r EXECUTABLE; do
  [[ $(file --mime-type --brief "${EXECUTABLE}") == *executable* ]] || continue
  lief-patchelf --remove-rpath                                                           "${EXECUTABLE}"
  lief-patchelf --set-rpath       "${OUT_DIR}/lib/x86_64-linux-gnu"                      "${EXECUTABLE}"
  lief-patchelf --set-interpreter "${OUT_DIR}/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2" "${EXECUTABLE}"
  lief-patchelf --force-rpath                                                            "${EXECUTABLE}"
done < <(command find "${OUT_DIR}" -type f -executable)
unset EXECUTABLE

log Finished
