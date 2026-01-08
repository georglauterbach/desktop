#! /usr/bin/env bash

# cSpell: ignore librsvg2 rtkit libvulkan1

function __root_setup() {
  readonly PACKAGES=(
      # sway and its associates are built from source; see custom/wayland/

      # ? TODO can this be removed?
      libdisplay-info1
      libgtk4-layer-shell0
      libliftoff0
      librsvg2-2
      libseat1
      libxcb-ewmh2

      # desktop portals
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr

      gnome-desktop-minimal                          # fallback DE & applications
      jq wdisplays wl-clipboard                      # sway companions
      pipewire pipewire-audio-client-libraries rtkit # audio
      libvulkan1 mesa-vulkan-drivers vulkan-tools    # graphics
      gnome-keyring                                  # secrets manager
      dex                                            # desktop file application launcher
      papers                                         # document viewer
      kitty                                          # terminal that visualizes files
      fonts-font-awesome                             # fonts
      adwaita-icon-theme                             # icons
  )

  # shellcheck disable=SC2154
  cp "${SCRIPT_DIR}/distributions/ubuntu/${VERSION_ID}/ppa/*" /etc/apt/sources.list.d/

  apt-get update
  apt-get --yes install --no-install-recommends --no-install-suggests "${PACKAGES[@]}"

  systemctl --user enable --now pipewire-pulse.service
}
