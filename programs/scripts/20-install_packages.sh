#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_root

readonly ADDITIONAL_PACKAGES=(
  # Ubuntu base system
  ubuntu-desktop-minimal # base package for a GUI
  # miscellaneous
  dex                    # desktop-file application launcher
  flatpak                # Flatpak
  git                    # version control system
  rtkit                  # real-time scheduling service (mostly used for audio)
  wl-clipboard           # Wayland clipboard
  xdg-desktop-portal-gtk # XDG-based portal frontend for GTK/GNOME
  xdg-utils              # common XDG utilities
  # fonts
  fonts-font-awesome     # Font Awesome
  fonts-ubuntu           # default Ubuntu (Sans) font
  # graphics
  gamemode               # run games in performance-mode
  mesa-vulkan-drivers    # Vulkan (graphics API) drivers by MESA
  vulkan-tools           # utilities for Vulkan
  wdisplays              # arrange displays on Wayland
  # sound
  pipewire               # API for dealing with multimedia pipelines
  pipewire-pulse         # Pulse Audio compatibility layer for pipewire
  wireplumber            # session & policy manager for pipewire
  # desktop apps
  gnome-calculator       # calculator
  gnome-characters       # character visualizer
  gnome-disk-utility     # disk management
  gnome-font-viewer      # character viewer
  gnome-keyring          # keyring daemon
  highlight              # used by GTK for syntax highlighting
  kitty                  # terminal emulator for yazi
  papers                 # documents viewer
  ptyxis                 # (fallback) terminal emulator
  resources              # resource usage monitor
)

log_info 'Installing packages'
apt-get install --yes --no-install-recommends "${ADDITIONAL_PACKAGES[@]}"
