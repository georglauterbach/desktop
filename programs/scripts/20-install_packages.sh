#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_root

# cSpell: disable
PACKAGES=(
  # ? XDG
  xdg-desktop-portal-gtk # XDG-based portal frontend for GTK/GNOME
  xdg-utils              # common XDG utilities
  # ? fonts
  fonts-font-awesome     # Font Awesome
  fonts-ubuntu           # default Ubuntu (Sans) font
  # ? graphics
  mesa-vulkan-drivers    # Vulkan (graphics API) drivers by MESA
  libvulkan1             # Vulkan loader
  vulkan-tools           # utilities for Vulkan
  # ? miscellaneous
  dex                    # desktop-file application launcher
  git                    # version control system
  rtkit                  # userland real-time scheduling
)
# cSpell: enable

# wdisplays              # arrange displays on Wayland

if [[ ${*} == *--ubuntu-desktop* ]]; then
  PACKAGES+=(
    ubuntu-desktop-minimal # Ubuntu desktop base package
    gnome-calculator       # calculator
    gnome-characters       # character visualizer
    gnome-disk-utility     # disk management
    gnome-font-viewer      # character viewer
    gnome-keyring          # keyring daemon
    highlight              # used by GTK for syntax highlighting
    papers                 # documents viewer
    ptyxis                 # (fallback) terminal emulator
    resources              # resource usage monitor
  )
fi


log_info 'Installing packages'
apt-get install --yes --no-install-recommends "${PACKAGES[@]}"
