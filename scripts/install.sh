#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

if [[ ${EUID} -ne 0 ]]; then
  echo "ERROR: This script needs to run with superuser privileges" >&2
  exit 1
fi

# 0. Navigate into the repository root
cd "$(realpath --canonicalize-existing --logical "$(dirname "${BASH_SOURCE[0]}")/..")"

# 1. Install (Determinate) Nix
sh <(curl --proto '=https' --tlsv1.3 -sSfL https://install.determinate.systems/nix) \
  install --nix-build-group-id 45000

# 2. Install the Nix profile
nix profile add .

# 3. Install additional packages
readonly ADDITIONAL_PACKAGES=(
  fonts-font-awesome
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-wlr
)
apt-get install --yes --no-install-recommends "${ADDITIONAL_PACKAGES[@]}"

# 4. Copy all configuration files into ${HOME}
cp --recursive --force config/{.config,.local} "${HOME}"

# 5. Link __sway into /usr/local/bin/
mkdir --parents /usr/local/bin
ln --symbolic --force "${HOME}/.local/bin/__sway" /usr/local/bin/__sway

# 6. Create a .desktop entry for Sway
mkdir --parents /usr/share/wayland-sessions
cat >/usr/share/wayland-sessions/sway.desktop <<"EOF"
[Desktop Entry]
Name=Sway
Exec=/usr/local/bin/__sway
Type=Application
EOF

# 7. Create PAM entry for swaylock
mkdir --parents /usr/local/etc/pam.d/
echo 'auth include login' >/usr/local/etc/pam.d/swaylock
