#! /usr/bin/env bash

# cSpell: ignore vsextensions vspackage

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  declare -r level=${1:?log level required}
  declare -r message=${2:?log message required}
  printf "%s \033[1m%5s\033[0m %s\n" "$(date --iso-8601=s)" "${level^^}" "${message}"
}

# Install extensions available through any
# of the following registries:
#
# 1. Microsoft Visual Studio Marketplace
#    https://marketplace.visualstudio.com
# 2. Open VSX Registry
#    https://open-vsx.org
function install_available_via_open_vsx() {
  # cSpell: disable
  declare -r extensions=(
    editorconfig.editorconfig
    edwinhuish.better-comments-next
    streetsidesoftware.code-spell-checker
    timonwong.shellcheck
    usernamehw.errorlens

    georglauterbach.evergruv
    navernoedenis.gruvbox-material-icons
  )
  # cSpell: enable

  local extension
  for extension in "${extensions[@]}"; do
    install_extension "${extension}" "${extension}"
  done
}

# Install extensions that are not available through
# the Open VSX Registry (https://open-vsx.org)
function install_not_available_via_open_vsx() {
  local download_dir publisher name version download
  declare -r base_uri='https://marketplace.visualstudio.com/_apis/public/gallery/publishers'

  download_dir=$(mktemp --directory)
  # shellcheck disable=SC2064
  trap "rm -r '${download_dir}'" EXIT

  while read -r publisher name version; do
    download="${download_dir}/${publisher}.${name}-${version}.vsix"
    curl -sSfL "${base_uri}/${publisher}/vsextensions/${name}/${version}/vspackage" \
      | gunzip >"${download}"
    install_extension "${publisher}.${name}" "${download}"
  done <<'EOF'
mads-hartmann bash-ide-vscode 1.43.2
EOF
}

function install_extension() {
  log info "Installing extension '${1:?extension name required}'"
  "${PROGRAM}" --install-extension "${2:?extension required}" >/dev/null
}

readonly PROGRAM=${1:-codium}

install_available_via_open_vsx
install_not_available_via_open_vsx
