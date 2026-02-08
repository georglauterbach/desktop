#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  echo -ne "\033[1m${*}\033[0m"
}

if [[ ${EUID} -ne 0 ]]; then
  log 'This script needs to run WITH superuser privileges' >&2
  exit 1
fi

readonly ADDITIONAL_PACKAGES=(
  #code
  dex
  #flatpak
  fonts-font-awesome
  gnome-keyring
  jq
  kitty
  pipewire
  rtkit
  seahorse
  swayimg
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-wlr
  #wireplumber
  wdisplays
  wl-clipboard
  zathura # papers also possible if host >= Ubuntu 25.04
)

apt-get install --yes --no-install-recommends "${ADDITIONAL_PACKAGES[@]}"
