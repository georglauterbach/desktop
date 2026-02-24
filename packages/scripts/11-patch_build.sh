#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

if ! command -v lief-patchelf &>/dev/null; then
  echo "ERROR The command 'lief-patchelf' could not be found. Download it from"       >&2
  echo '      https://lief.re/blog/2025-07-13-patchelf/#download or build it (see'    >&2
  echo '      https://lief.re/doc/stable/tools/lief-patchelf/index.html#compilation)' >&2
  exit 1
fi

if [[ ${EUID} -ne 0 ]]; then
  log 'This script needs to run WITH superuser privileges' >&2
  exit 1
fi

RUNTIME_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")/..")
OUT_DIR=${RUNTIME_DIR}/out

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
