#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_user
require_command podman

mkdir -p "${APT_DIR}"/{cache,lists} "${CACHE_DIR}" "${OUT_DIR}" "${SRC_DIR}"

log_info Building
podman build --tag "${IMAGE_TAG}" --file Containerfile \
  --volume "${APT_DIR}/cache:/var/cache/apt"           \
  --volume "${APT_DIR}/lists:/var/lib/apt/lists"       \
  --volume "${CACHE_DIR}:/root/.cache"                 \
  --volume "${SRC_DIR}:/src"                           \
  .

log_info 'Copying files'
podman run --rm --volume "${OUT_DIR}:/out" "${IMAGE_TAG}" \
  /bin/bash -c "cp --recursive /usr/local/* /out/"
