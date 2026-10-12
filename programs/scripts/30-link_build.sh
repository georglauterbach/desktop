#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_root

log_info 'Linking files into /usr/local/'
while read -r FILE; do
  LINK_NAME=/usr/local/${FILE#"${OUT_DIR}/"}
  mkdir -p "$(dirname "${LINK_NAME}")"
  if [[ ${FILE} == *'/libexec/glycin-loaders/'* ]]; then
    # glycin runs these loaders inside a `bwrap --unshare-all` sandbox that only
    # binds `/usr`; a symlink into `${OUT_DIR}` is unresolvable there, so the
    # loaders must exist as real files under `/usr/local`.
    cp --force --dereference "${FILE}" "${LINK_NAME}"
  else
    ln --symbolic --force "${FILE}" "${LINK_NAME}"
  fi
done < <(command find "${OUT_DIR}/"{bin,etc,lib/{udev,systemd/user},libexec,man,share/{applications,bash-completion,dbus-1,glib-2.0,glycin-loaders,icons,libinput,man,metainfo,rofi,wayland*,xdg-desktop-portal}} -type f)

log_info 'Removing superfluous files'
rm -f /usr/local/share/wayland-sessions/sway.desktop
