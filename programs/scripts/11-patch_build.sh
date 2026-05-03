#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

# ! The order and the exact commands that we use to patch the shared
#   objects and executables is very important.

require_run_as_user
require_command lief-patchelf

function patchelf() { lief-patchelf "${@}" ; }

log_info "Deleting empty directories in '${OUT_DIR}'"
find "${OUT_DIR}" -type d -empty -delete
find "${OUT_DIR}" -type d -empty -delete
find "${OUT_DIR}" -type d -empty -delete

log_info "Patching files in '${OUT_DIR}'"
while read -r SHARED_OBJECT; do
  [[ ${SHARED_OBJECT} == *ld-linux-x86-64.so.2 ]] && continue
  patchelf --remove-rpath                                "${SHARED_OBJECT}" || :
  patchelf --set-rpath "${OUT_DIR}/lib/x86_64-linux-gnu" "${SHARED_OBJECT}" || :
  patchelf --force-rpath                                 "${SHARED_OBJECT}" || :
done < <(command find "${OUT_DIR}/lib/" -type f -name '*.so*')

while read -r EXECUTABLE; do
  # glycin loaders are executed inside a `bwrap --unshare-all` sandbox that only
  # binds `/usr`; rewriting their interpreter/RPATH into `${OUT_DIR}` (outside the
  # sandbox) makes them unrunnable, so they must keep the stock system values.
  [[ ${EXECUTABLE} == *'/libexec/glycin-loaders/'* ]] && continue

  [[ $(file --mime-type --brief "${EXECUTABLE}") == *executable* ]] || continue
  patchelf --remove-rpath                                                           "${EXECUTABLE}" || :
  patchelf --set-rpath       "${OUT_DIR}/lib/x86_64-linux-gnu"                      "${EXECUTABLE}" || :
  patchelf --set-interpreter "${OUT_DIR}/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2" "${EXECUTABLE}" || :
  patchelf --force-rpath                                                            "${EXECUTABLE}" || :
done < <(command find "${OUT_DIR}" -type f -executable)
