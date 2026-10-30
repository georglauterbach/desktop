#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR=$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")

# shellcheck source=00-env.sh
source "${SCRIPT_DIR}/00-env.sh"

require_run_as_root

log_info 'Cleaning up files in /usr/local/'
rm -f \
  /usr/lib/x86_64-linux-gnu/security/pam_gnome_keyring.so \
  /usr/local/bin/__sway /usr/share/wayland-sessions/swayfx.desktop
while read -r FILE; do
  [[ $(readlink -n "${FILE}") == "${OUT_DIR}"* ]] && rm -v "${FILE}"
done < <(command find /usr/local/ -type l)
