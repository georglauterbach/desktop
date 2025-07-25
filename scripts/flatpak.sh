#! /usr/bin/env bash

# ref: https://github.com/flatpak/flatpak
#      https://flatpak.org/setup/Ubuntu

set -eE -u -o pipefail
shopt -s inherit_errexit

if ! command -v flatpak &>/dev/null; then
  SUDO_CMD='export DEBIAN_FRONTEND=noninteractive ; export DEBCONF_NONINTERACTIVE_SEEN=true ;'
  SUDO_CMD+='apt-get --yes update && apt-get --yes install flatpak malcontent-gui'
  sudo bash -c "${SUDO_CMD}"
fi

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

read -r -p 'Do you want to install additional extra programs? [y/N] ' RESPONSE
if [[ ${RESPONSE,,} =~ ^(y(es)?)$ ]]; then
  readonly EXTRA_PROGRAMS=(
    'app.zen_browser.zen'
    'com.bitwarden.desktop'
    'com.discordapp.Discord'
    'com.github.tchx84.Flatseal'
    'com.valvesoftware.Steam'
    'eu.betterbird.Betterbird'
    'org.cryptomator.Cryptomator'
    'org.libreoffice.LibreOffice'
  )

  flatpak install --noninteractive --or-update flathub "${EXTRA_PROGRAMS[@]}"
fi

echo "Restart you machine for changes to take effect"
