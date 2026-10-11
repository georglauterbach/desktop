#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_user

log_info 'Adding Flathub remote if it does not exist already'
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# cSpell: disable
readonly FLATPAKS=(
  app.zen_browser.zen
  com.github.tchx84.Flatseal
  #com.bitwarden.desktop
  #com.valvesoftware.Steam
  #org.freedesktop.Platform.VulkanLayer.MangoHud
  #eu.betterbird.Betterbird
  #org.cryptomator.Cryptomator
  #org.libreoffice.LibreOffice
  #be.alexandervanhee.gradia
  #com.github.IsmaelMartinez.teams_for_linux
)
# cSpell: enable

log 'Installing Flatpaks'
flatpak install --noninteractive --or-update flathub "${FLATPAKS[@]}" "${@}"
