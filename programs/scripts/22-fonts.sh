#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_root

readonly NERD_FONT_VERSION='v3.4.0'

function download_extract_place() {
  local FONT_NAME=${1:?Font name required}

  local URI="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/${FONT_NAME}.tar.xz"
  local TARGET_DIR="/usr/local/share/fonts/${FONT_NAME}-Nerd-Font"

  rm -rf "${TARGET_DIR}"
  mkdir -p "${TARGET_DIR}"
  curl -sSfL "${URI}" | tar xJ -C "${TARGET_DIR}"
  chown -R root:root "${TARGET_DIR}"
}

log_info 'Installing fonts'
download_extract_place 'FiraCode'
download_extract_place 'JetBrainsMono'
download_extract_place 'UbuntuSans'

# we update the font cache and try again if the first time failed
log_info 'Updating font cache'
fc-cache -f &>/dev/null || fc-cache -f
