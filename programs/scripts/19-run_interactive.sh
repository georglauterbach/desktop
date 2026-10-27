#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_user
require_command podman

mkdir -p "${OUT_DIR}"

log_info 'Running interactive container for testing purposes'
podman run --rm --interactive --tty              \
  --volume "${APT_DIR}/cache:/var/cache/apt"     \
  --volume "${APT_DIR}/lists:/var/lib/apt/lists" \
  --volume "${CACHE_DIR}:/root/.cache"           \
  --volume "${SRC_DIR}:/src"                     \
  "${IMAGE_TAG}" bash
