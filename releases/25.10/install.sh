#! /usr/bin/env bash

# cSpell: ignore librsvg2 rtkit libvulkan1

function __root_setup() {
  readonly PACKAGES=(
      # sway and its associates are built from source; see custom/wayland/

      # fallback DE & applications
      gnome-desktop-minimal

      # programs associated with Sway for core functionality
      adwaita-icon-theme
      libdisplay-info1
      libgtk4-layer-shell0
      libliftoff0
      librsvg2-2
      libseat1
      libxcb-ewmh2
      jq
      wdisplays

      # to support applications that only run on X11,
      # xwayland provides a compatibility layer
      xwayland

      # fonts
      fonts-font-awesome

      # desktop portals
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr

      # audio (processing engine)
      pipewire pipewire-audio-client-libraries rtkit

      # graphics (API)
      libvulkan1 mesa-vulkan-drivers vulkan-tools

      # document viewer
      papers

      # application launcher
      dex

      # terminal that visualizes files
      kitty

      # secrets manager
      gnome-keyring
  )

  # shellcheck disable=SC2154
  cp "${SCRIPT_DIR}/distributions/ubuntu/${VERSION_ID}/ppa/*" /etc/apt/sources.list.d/

  apt-get update
  apt-get --yes install --no-install-recommends --no-install-suggests "${PACKAGES[@]}"

  systemctl --user enable --now pipewire-pulse.service
}
