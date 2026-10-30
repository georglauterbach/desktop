#! /usr/bin/env bash

set +eE -u -o pipefail
shopt -s inherit_errexit

function set_wallpaper() {
  for _ in {1..20}; do awww query &>/dev/null && break; sleep 0.1; done
  awww img "${HOME}/.config/sway/theme/wallpaper" --transition-type fade --transition-duration 0.4
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
# we activate it via `sway-session.target`, which binds it. The target also
# pulls in the units linked in `sway-session.target.wants/`; a unit that hit its
# start limit in a previous session would be refused, hence `reset-failed`.
systemctl --user reset-failed &>/dev/null || :
systemctl --user start sway-session.target ssh-agent.service

set_wallpaper &

# shellcheck source=/dev/null
[[ ! -s ${HOME}/.config/sway/user/init.sh ]] || source "${HOME}/.config/sway/user/init.sh"

wait -f
