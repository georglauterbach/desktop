#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_user
require_command podman

if [[ ${1:-} == '--force' ]]; then
  rm -rf "${OUT_DIR}"
fi

mkdir -p "${OUT_DIR}"

log_info 'Running and copying files'
podman run --rm --volume "${OUT_DIR}:/out" "${IMAGE_TAG}" \
  /bin/bash -c "cp --recursive /usr/local/* /out/"
