#! /usr/bin/env bash

function __root_setup() {
  readonly PACKAGES=(
      # a package that provides common dependencies that Sway needs too;
      # can also be used as a fallback in case SwayWM is inaccessible or does not work
      ubuntu-desktop-minimal

      # the actual Wayland compositor;
      # installed for easy dependencies to SwayFX
      sway

      # programs associated with Sway for core functionality
      sway-notification-center libgtk4-layer-shell0
      swayidle
      swaylock librsvg2-2
      jq

      # to support applications that only run on X11,
      # xwayland provides a compatibility layer
      xwayland

      # application launcher
      rofi

      # the main bar
      waybar

      # the main terminal
      alacritty

      # fonts
      fonts-font-awesome

      # desktop portals
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr

      # audio (processing engine)
      pipewire pipewire-audio-client-libraries rtkit wireplumber

      # graphics (API)
      libvulkan1 mesa-vulkan-drivers vulkan-tools

      # screenshots
      grimshot

      # document viewer
      papers
  )

  # shellcheck disable=SC2154
  cp "${SCRIPT_DIR}/distributions/ubuntu/${VERSION_ID}/ppa/*" /etc/apt/sources.list.d/

  apt-get --yes update
  apt-get --yes install --no-install-recommends --no-install-suggests "${PACKAGES[@]}"
  apt-get --yes purge wmenu

  rm --force /etc/systemd/user/graphical-session.target.wants/{waybar,swaync}.service
  systemctl --user disable waybar.service || :
  systemctl --user mask    waybar.service || :
  systemctl --user disable swaync.service || :
  systemctl --user mask    swaync.service || :

  systemctl --user enable --now pipewire-pulse.service
}
