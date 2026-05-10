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
  # base system
  ubuntu-desktop-minimal # base package for a GUI
  highlight              # used by GTK for sytaxt highlighting
  systemd-oomd           # monitor and take action before OOM hits
  # miscellaneous
  dex                    # desktop-file application launcher
  flatpak                # Flatpak
  gcc                    # compilers (mostly for C)
  git                    # version control system
  rtkit                  # real-time scheduling service
  wl-clipboard           # Wayland clipboard
  xdg-desktop-portal     # portal frontend service
  xdg-desktop-portal-wlr #   -- wlroots
  xdg-desktop-portal-gtk #   -- GTK+/GNOME
  xdg-utils              # common XDG utilities
  # fonts
  fonts-font-awesome     # Font Awesome
  fonts-ubuntu           # default Ubuntu (Sans) font
  # graphics
  gamemode               # run games in performance-mode
  mesa-vulkan-drivers    # Vulkan (graphics API) drivers by MESA
  wdisplays              # arrange displays on Wayland
  # sound
  pipewire               # API for dealing with multimedia pipelines
  wireplumber            # session & policy manager for pipewire
  # desktop apps
  gnome-calculator       # calculator
  gnome-characters       # character visualizor
  gnome-disk-utility     # disk management
  gnome-keyring          # keyring daemon
  kitty                  # terminal emulator for yazi
  papers                 # documents viewer
  ptyxis                 # (fallback) terminal emulator
  resources              # resource usage monitor
)

apt-get install --yes --no-install-recommends "${ADDITIONAL_PACKAGES[@]}"
