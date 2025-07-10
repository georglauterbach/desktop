#! /usr/bin/env bash

function __root_setup() {
  readonly PACKAGES=(
      # a package that provides common dependencies that Sway needs too;
      # can also be used as a fallback in case SwayWM is inaccessible or does not work
      ubuntu-desktop-minimal

      # the actual Wayland compositor
      sway

      # programs associated with Sway for core functionality
      sway-backgrounds sway-notification-center swayidle swaylock
      jq librsvg2-2

      # to support applications that only run on X11,
      # xwayland provides a compatibility layer
      xwayland

      # the main bar
      waybar

      # the main terminal
      alacritty

      # fonts
      fonts-font-awesome

      # desktop portals
      xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr

      # audio (processing engine)
      pipewire pipewire-audio-client-libraries pulseaudio-utils rtkit wireplumber

      # graphics (API)
      libvulkan1 mesa-vulkan-drivers vulkan-tools

      # screenshots
      grimshot

      # document viewer
      papers
  )


  apt-get --yes update
  apt-get --yes install --no-install-recommends --no-install-suggests "${PACKAGES[@]}"





  # TODO
  rm --force /etc/systemd/user/graphical-session.target.wants/{waybar,swaync}.service
  apt-get --yes purge wmenu

  systemctl --user disable swaync.service waybar.service || :
  systemctl --user enable --now pipewire-pulse.service
}

