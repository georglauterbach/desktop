#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

if [[ ${EUID} -ne 0 ]]; then
  echo 'Run this script as root' >&2
  exit 1
fi

SCRIPT_DIR="$(realpath -eL "$(dirname "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR

readonly UBUNTU_VERSION=${1:-2404}

cd "${SCRIPT_DIR}/../${UBUNTU_VERSION}"
docker compose up --build

cp --force --recursive out/* /usr/local/
cp "${SCRIPT_DIR}/__sway" /usr/local/bin/
sed --in-place 's|Exec=.*|Exec=__sway|' /usr/local/share/wayland-sessions/sway.desktop

sudo mkdir -p /usr/local/share/X11/xkb/rules
ln --symbolic --force /usr/share/X11/xkb/rules/evdev /usr/local/share/X11/xkb/rules/
ln --symbolic --force /usr/bin/xkbcomp /usr/local/bin/xkbcomp
