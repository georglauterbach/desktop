#! /usr/bin/env bash

# cSpell: disable

# ref: https://github.com/flatpak/flatpak
#      https://flatpak.org/setup/Ubuntu

set -eE -u -o pipefail
shopt -s inherit_errexit

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

readonly EXTRA_PROGRAMS=(
  'app.zen_browser.zen'
  'com.bitwarden.desktop'
  'com.github.tchx84.Flatseal'
  'com.valvesoftware.Steam'
  'eu.betterbird.Betterbird'
  'org.cryptomator.Cryptomator'
  'org.libreoffice.LibreOffice'
)

flatpak install --noninteractive --or-update flathub "${EXTRA_PROGRAMS[@]}"
