#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_user

if ! command -v flatpak &>/dev/null; then
  log_info 'Installing flatpak'
  sudo apt-get install --no-install-recommends flatpak
fi

log_info 'Adding Flathub remote if it does not exist already'
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# cSpell: disable
readonly FLATPAKS=(
  # essentials
  com.github.tchx84.Flatseal

  # GNOME apps
  app.devsuite.Ptyxis
  net.nokyan.Resources
  org.gnome.Calculator
  org.gnome.Characters
  org.gnome.font-viewer
  org.gnome.Papers

  # personal apps
  app.zen_browser.zen
  #com.bitwarden.desktop
  #com.valvesoftware.Steam
  #eu.betterbird.Betterbird
  #md.obsidian.Obsidian
  #net.lutris.Lutris
  #org.cryptomator.Cryptomator
  #org.freedesktop.Platform.VulkanLayer.MangoHud

  # work
  #com.github.IsmaelMartinez.teams_for_linux
)
# cSpell: enable

log_info 'Installing Flatpaks'
flatpak --user install --noninteractive --or-update flathub "${FLATPAKS[@]}" "${@}"

# ? Remove all flatpaks with
#   flatpak uninstall --all --delete-data --user
