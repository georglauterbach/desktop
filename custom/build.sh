#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

log 'Running pre-build commands.. '

for COMMAND in patchelf file earthly; do
  if ! command -v "${COMMAND}" &>/dev/null; then
    log "Command '${COMMAND}' not found but required"
    exit 1
  fi
done

log 'done\nStarting build..\n\n'

earthly -i --strict "+${1:-finish}"

log '\n.. done\nRunning post-build commands..\n'

OUT_DIR=$(realpath --canonicalize-existing --logical out)
mkdir --parents "${HOME}/.local/bin"

command find "${OUT_DIR}" -type d -empty -delete

while read -r EXECUTABLE; do
  [[ $(file --mime-type --brief "${EXECUTABLE}") == *executable* ]] || continue
  patchelf --set-rpath "${OUT_DIR}/lib/x86_64-linux-gnu"           "${EXECUTABLE}"
  patchelf --shrink-rpath                                          "${EXECUTABLE}"
done < <(command find "${OUT_DIR}" -type f -executable)
unset EXECUTABLE

while read -r SHARED_OBJECT; do
  patchelf --set-rpath "${OUT_DIR}/lib/x86_64-linux-gnu" "${SHARED_OBJECT}"
  patchelf --shrink-rpath                                "${SHARED_OBJECT}"
done < <(command find "${OUT_DIR}/lib/" -type f -name '*.so*')
unset SHARED_OBJECT

patchelf --add-rpath "${OUT_DIR}/lib/stdc++" "${OUT_DIR}/bin/waybar"

log 'done\n'
