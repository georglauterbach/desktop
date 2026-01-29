#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log_important() {
  echo -ne "\033[1m${*}\033[0m"
}

log_important 'Running pre-build commands.. '

for COMMAND in patchelf file earthly; do
  if ! command -v "${COMMAND}" &>/dev/null; then
    log_important "Command '${COMMAND}' not found but required"
    exit 1
  fi
done

log_important 'done\nStarting build..\n\n'

earthly --strict "+${1:-associates}"

log_important '\n.. done\nRunning post-build commands.. '

OUT_DIR=$(realpath --canonicalize-existing --logical out)

while read -r EXECUTABLE; do
  [[ $(file --mime-type --brief "${EXECUTABLE}") == *executable* ]] || continue
  patchelf --set-rpath "${OUT_DIR}/lib"                  "${EXECUTABLE}"
  patchelf --set-rpath "${OUT_DIR}/lib/x86_64-linux-gnu" "${EXECUTABLE}"
  patchelf --shrink-rpath                                "${EXECUTABLE}"
done < <(command find "${OUT_DIR}" -type f -executable)

log_important 'done\n'
