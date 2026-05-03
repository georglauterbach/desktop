#! /usr/bin/env bash

# cSpell: ignore SWAYSOCK

set +eE -u -o pipefail
shopt -s inherit_errexit

function systemd_start_user_service() {
  local SERVICE=${1:?Service name required}.service
  if systemctl --user is-failed "${SERVICE}" &>/dev/null; then
    systemctl --user restart "${SERVICE}"
  elif ! systemctl --user is-active "${SERVICE}" &>/dev/null; then
    systemctl --user start "${SERVICE}"
  fi
}

function set_wallpaper() {
  for _ in {1..20}; do awww query &>/dev/null && break; sleep 0.1; done
  awww img "${HOME}/.config/sway/theme/wallpaper.svg" \
    --transition-type simple --transition-fps 60 --transition-duration 1
}

# Some variables need to be exported to systemd and/or dbus activation
# environments so tools that rely on them work properly.
readonly ENVIRONMENT=(DISPLAY WAYLAND_DISPLAY SWAYSOCK I3SOCK)
systemctl --user import-environment          "${ENVIRONMENT[@]}"
dbus-update-activation-environment --systemd "${ENVIRONMENT[@]}" || :

# `xdg-desktop-portal.service` (and the other portals) declare
# `Requisite=graphical-session.target`, so that target MUST be active before
# they can start; otherwise portal D-Bus activation times out and blocks GTK
# clients (e.g. swaync). `graphical-session.target` refuses a manual start, so
# we activate it via `sway-session.target`, which binds it.
systemctl --user start sway-session.target

set_wallpaper &

readonly SERVICES=(xdg-desktop-portal{,-wlr,-gtk} awww-daemon shikane swaync waybar) # ianny
for SERVICE in "${SERVICES[@]}"; do
  systemd_start_user_service "${SERVICE}"
done
unset SERVICE

# shellcheck source=/dev/null
[[ ! -s ${HOME}/.config/sway/user/init.sh ]] || source "${HOME}/.config/sway/user/init.sh"

wait -f
