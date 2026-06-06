#! /usr/bin/env bash

# cSpell: disable

# ref: https://github.com/flatpak/flatpak
#      https://flatpak.org/setup/Ubuntu

set -eE -u -o pipefail
shopt -s inherit_errexit

if [[ ${EUID} -eq 0 ]]; then
  log 'ERROR  This script MUST NOT run with superuser privileges' >&2
  exit 1
fi

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

readonly EXTRA_PROGRAMS=(
  app.zen_browser.zen
  com.bitwarden.desktop
  com.github.tchx84.Flatseal
  com.valvesoftware.Steam
  org.freedesktop.Platform.VulkanLayer.MangoHud
  eu.betterbird.Betterbird
  org.cryptomator.Cryptomator
  org.libreoffice.LibreOffice
  #com.github.IsmaelMartinez.teams_for_linux
)

flatpak install --noninteractive --or-update flathub "${EXTRA_PROGRAMS[@]}"
