#! /usr/bin/env bash

# cSpell: ignore SWAYSOCK shikane swaync waybar

# Some variables need to be exported to systemd
# and/or dbus activation environments so tools
# that rely on them work properly.
#
# Applications that are started as systemd (user)
# services or that rely on D-Bus, or those that
# trigger D-Bus, MUST be started in
#
# ${HOME}/.config/sway/user/init.sh
#
# to ensure they are started AFTER we imported
# the correct environment variables to systemd
# and D-Bus.
#
# ref: https://github.com/swaywm/sway/wiki#systemd-and-dbus-activation-environments
# ref: https://github.com/swaywm/sway/issues/5841

set +eE -u -o pipefail
shopt -s inherit_errexit

systemctl --user import-environment          DISPLAY WAYLAND_DISPLAY SWAYSOCK I3SOCK
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK I3SOCK

for SERVICE in xdg-desktop-portal{,-wlr,-gtk}.service; do
  if systemctl --user is-failed "${SERVICE}" &>/dev/null; then
    systemctl --user restart "${SERVICE}"
  elif ! systemctl --user is-active "${SERVICE}" &>/dev/null; then
    systemctl --user start "${SERVICE}"
  fi
done
unset SERVICE

# `shikane` manages screen arrangements
bash -c 'exec shikane                    >/tmp/.sway.shikane.log 2>/tmp/.sway.shikane.err.log' &
# `swaync` provides a notification center
bash -c 'exec swaync                     >/tmp/.sway.swaync.log  2>/tmp/.sway.swaync.err.log'  &
# `waybar` provides a bar
bash -c 'exec waybar --log-level warning >/tmp/.sway.waybar.log  2>/tmp/.sway.waybar.err.log'  &

# shellcheck source=/dev/null
[[ ! -e ${HOME}/.config/sway/user/init.sh ]] || source "${HOME}/.config/sway/user/init.sh"
