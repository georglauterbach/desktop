#! /usr/bin/env bash

# cSpell: ignore librsvg2 rtkit libvulkan1

function __root_setup() {
  readonly PACKAGES=(
      # sway and its associates are built from source; see custom/wayland/

      # ? TODO can this be removed?
      libdisplay-info1 # yes
      libgtk4-layer-shell0
      libliftoff0 # yes
      librsvg2-2  => librsvg2-dev
      libseat1
      libxcb-ewmh2

      # sway companions
      jq
      wdisplays

      # desktop portals
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr

      # secrets manager
      gnome-keyring
      libsecret-1-0
      libsecret-tools
      seahorse

      # audio
      pipewire
      pipewire-audio-client-libraries
      rtkit

      # graphics
      libvulkan1
      mesa-vulkan-drivers
      vulkan-tools

      #gnome-desktop-minimal    # fallback DE & applications
      dex                       # desktop file application launcher
      papers                    # document viewer
      kitty                     # terminal that visualizes files
      fonts-font-awesome        # fonts
      adwaita-icon-theme        # icons
  )

  # shellcheck disable=SC2154
  cp "${SCRIPT_DIR}/distributions/ubuntu/${VERSION_ID}/ppa/*" /etc/apt/sources.list.d/

  apt-get update
  apt-get --yes install --no-install-recommends --no-install-suggests "${PACKAGES[@]}"

  systemctl --user enable --now pipewire-pulse.service
}
