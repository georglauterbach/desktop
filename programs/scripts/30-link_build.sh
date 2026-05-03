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
done < <(command find "${OUT_DIR}/"{bin,etc,lib/{udev,systemd/user},libexec,man,share/{applications,bash-completion,dbus-1,glib-2.0,glycin-loaders,icons,libinput,man,metainfo,nwg-look,rofi,wayland*,xdg-desktop-portal}} -type f)

log_info 'Removing superfluous files'
rm -f /usr/local/share/wayland-sessions/sway.desktop

log_info 'Patching GTK4 apps'
mkdir -p /usr/local/lib/x86_64-linux-gnu
cp "${OUT_DIR}/lib/x86_64-linux-gnu/libgtk4-layer-shell.so.1.3.0" \
  /usr/local/lib/x86_64-linux-gnu/libgtk4-layer-shell.so.0
for APPLICATION_NAME in swaync wleave; do
  APPLICATION="/usr/local/bin/${APPLICATION_NAME}"
  rm -f "${APPLICATION}"
  cat >"${APPLICATION}" <<EOF
#! /bin/sh

exec "${OUT_DIR}/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2"              \\
    --preload "${OUT_DIR}/lib/x86_64-linux-gnu/libgtk4-layer-shell.so.0" \\
    --argv0 "${APPLICATION_NAME}" \\
    "${OUT_DIR}/bin/${APPLICATION_NAME}" "\${@}"
EOF
  chmod +x "${APPLICATION}"
done
