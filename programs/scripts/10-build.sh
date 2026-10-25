#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_user
require_command podman

if [[ ${1:-} == '--force' ]]; then
  rm -rf "${APT_DIR}"/{cache,lists} "${CACHE_DIR}" "${SRC_DIR}"
fi

mkdir -p "${APT_DIR}"/{cache,lists} "${CACHE_DIR}" "${SRC_DIR}"

log_info Building
nice --adjustment=19 podman build                \
  --tag "${IMAGE_TAG}" --file Containerfile      \
  --volume "${APT_DIR}/cache:/var/cache/apt"     \
  --volume "${APT_DIR}/lists:/var/lib/apt/lists" \
  --volume "${CACHE_DIR}:/root/.cache"           \
  --volume "${SRC_DIR}:/src"                     \
  .
