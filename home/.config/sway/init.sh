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

# Some variables need to be exported to systemd and/or dbus activation
# environments so tools that rely on them work properly.
readonly ENVIRONMENT=(DISPLAY WAYLAND_DISPLAY SWAYSOCK I3SOCK)
systemctl --user import-environment          "${ENVIRONMENT[@]}"
dbus-update-activation-environment --systemd "${ENVIRONMENT[@]}" || :

readonly SERVICES=(xdg-desktop-portal{,-wlr,-gtk} shikane ianny waybar swaync)
for SERVICE in "${SERVICES[@]}"; do
  systemd_start_user_service "${SERVICE}"
done
unset SERVICE

# shellcheck source=/dev/null
[[ ! -s ${HOME}/.config/sway/user/init.sh ]] || source "${HOME}/.config/sway/user/init.sh"
