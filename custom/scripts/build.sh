#! /usr/bin/env bash

# cSpell: ignore Ddocumentation Drfkill Dwireplumber Dcava Dpam Dxcb Dwayland Dxwayland Dlogind
# cSpell: ignore Alexays davatorium ErikReider Satty scenefx waycrate wlrfx

set -eE -u -o pipefail
shopt -s inherit_errexit

# -----------------------------------------------
# ----  Build Functions  ------------------------
# -----------------------------------------------

function build_package() {
  local GIT_URI=${1:?URI for cloning via git is required}
  shift 1

  local DIR_NAME=${GIT_URI/#*\/}

  local GIT_REV_VAR_NAME=GIT_REV_${DIR_NAME^^}
  GIT_REV_VAR_NAME=${GIT_REV_VAR_NAME//-/_}

  if [[ ! -v ${GIT_REV_VAR_NAME} ]]; then
    echo "ENV '${GIT_REV_VAR_NAME}' for git revision of '${DIR_NAME}' required but unset" >&2
    exit 1
  fi

  [[ -d ${DIR_NAME} ]] || git clone "http://${GIT_URI}.git/"
  (
    cd "${DIR_NAME}"
    git fetch --prune --tags --force
    git checkout "${!GIT_REV_VAR_NAME:?}"
    "${@:-run_meson_ninja}"
  )
}

function run_meson_ninja() {
  meson setup build --reconfigure --buildtype=release --prefix="${INSTALLATION_PREFIX}" "${@}"
  ninja -C build install
}

# -----------------------------------------------
# ----  Rust Setup  -----------------------------
# -----------------------------------------------

export CARGO_HOME=/src/rust/cargo/home RUSTUP_HOME=/src/rust/rustup/home
readonly CARGO_HOME RUSTUP_HOME
# shellcheck source=/dev/null
source "${HOME}/.cargo/env"
rustup default "${RUST_TOOLCHAIN_VERSION:?}"

# -----------------------------------------------
# ----  Prologue  -------------------------------
# -----------------------------------------------

readonly INSTALLATION_PREFIX=/usr/local
mkdir --parents "${INSTALLATION_PREFIX}/share/"{applications,man/{1,5,7}}

cd /src

# -----------------------------------------------
# ----  Wayland Base Dependencies  --------------
# -----------------------------------------------

# build_package gitlab.freedesktop.org/wayland/wayland run_meson_ninja -Ddocumentation=false
# build_package gitlab.freedesktop.org/wayland/wayland-protocols

# -----------------------------------------------
# ----  Xwayland  -------------------------------
# -----------------------------------------------

build_package gitlab.freedesktop.org/xorg/proto/xorgproto
build_package gitlab.freedesktop.org/xorg/xserver run_meson_ninja

# -----------------------------------------------
# ----  Additional Libraries  -------------------
# -----------------------------------------------

# build_package gitlab.freedesktop.org/pipewire/wireplumber
# build_package gitlab.freedesktop.org/libinput/libinput
# build_package gitlab.freedesktop.org/pixman/pixman

# -----------------------------------------------
# ----  Sway & Companions  ----------------------
# -----------------------------------------------

# build_package gitlab.freedesktop.org/wlroots/wlroots run_meson_ninja -Dxwayland=enabled
# build_package github.com/swaywm/sway
# build_package github.com/swaywm/swaybg
# build_package github.com/swaywm/swayidle
# build_package github.com/swaywm/swaylock \
#   run_meson_ninja -Dpam=enabled
# build_package github.com/ErikReider/SwayAudioIdleInhibit \
#   run_meson_ninja -Dlogind-provider=systemd

# -----------------------------------------------
# ----  SwayFX  ---------------------------------
# -----------------------------------------------

# build_package github.com/wlrfx/scenefx
# build_package github.com/WillPower3309/swayfx

# -----------------------------------------------
# ----  Additional Programs  --------------------
# -----------------------------------------------

# build_package github.com/davatorium/rofi \
#   run_meson_ninja -Dxcb=disabled -Dwayland=enabled
# build_package github.com/ErikReider/SwayNotificationCenter
# build_package github.com/Alexays/Waybar \
#   run_meson_ninja -Drfkill=enabled -Dwireplumber=enabled -Dcava=disabled

function install_alacritty() {
  cargo build --release --no-default-features --features=wayland
  cp target/release/alacritty "${INSTALLATION_PREFIX}/bin"

  scdoc < extra/man/alacritty.1.scd          | gzip -c >"${INSTALLATION_PREFIX}/share/man/man1/alacritty.1.gz"
  scdoc < extra/man/alacritty-msg.1.scd      | gzip -c >"${INSTALLATION_PREFIX}/share/man/man1/alacritty-msg.1.gz"
  scdoc < extra/man/alacritty.5.scd          | gzip -c >"${INSTALLATION_PREFIX}/share/man/man5/alacritty.5.gz"
  scdoc < extra/man/alacritty-bindings.5.scd | gzip -c >"${INSTALLATION_PREFIX}/share/man/man5/alacritty-bindings.5.gz"
}
# build_package github.com/alacritty/alacritty install_alacritty

function install_shikane() {
  cargo build --release

  install -s -Dm755 target/release/shikane    -t "${INSTALLATION_PREFIX}/bin/"
  install -s -Dm755 target/release/shikanectl -t "${INSTALLATION_PREFIX}/bin/"
}
# build_package gitlab.com/w0lff/shikane install_shikane

# function install_wayshot() {
#   cargo build --release
#   install -s -Dm755 target/release/wayshot -t "${INSTALLATION_PREFIX}/bin"
#   find ./docs -type f -iname '*.1.gz' -exec cp -f {} /out/share/man/man1/ \;
#   find ./docs -type f -iname '*.5.gz' -exec cp -f {} /out/share/man/man5/ \;
#   find ./docs -type f -iname '*.7.gz' -exec cp -f {} /out/share/man/man7/ \;
# }
# build_package github.com/waycrate/wayshot install_wayshot

function install_satty() {
  cargo build --release
  install -s -Dm755 target/release/satty -t "${INSTALLATION_PREFIX}/bin/"

  mkdir --parents "${INSTALLATION_PREFIX}/share/"{icons/hicolor/scalable/apps,licenses/satty}

  install -Dm644 assets/satty.svg "${INSTALLATION_PREFIX}/share/icons/hicolor/scalable/apps/satty.svg"
  install -Dm644 satty.desktop    "${INSTALLATION_PREFIX}/share/applications/satty.desktop"

  install -Dm644 LICENSE ${INSTALLATION_PREFIX}/share/licenses/satty/LICENSE
}
# build_package github.com/Satty-org/Satty install_satty

function install_lightctl() {
  cargo build --release
  install -s -Dm755 target/release/lightctl -t "${INSTALLATION_PREFIX}/bin/"
}
# build_package https://github.com/blurrycat/lightctl.git

# -----------------------------------------------
# ----  Epilogue  -------------------------------
# -----------------------------------------------

for PROGRAM in "${INSTALLATION_PREFIX}/bin/"*; do
  grep --quiet 'dynamically linked' <(file "${PROGRAM}") || continue

  while read -r _ _ FILE _; do
    # cSpell: disable-next-line
    [[ ${FILE} =~ .*lib(c|stdc\+\+)\.so\.[0-9]+ ]] && continue
    [[ -e ${INSTALLATION_PREFIX}${FILE} ]] && continue

    echo "Copying '${FILE}' to '${INSTALLATION_PREFIX}${FILE}'"
    mkdir --parents "${INSTALLATION_PREFIX}/$(dirname "${FILE}")"
    cp "${FILE}" "${INSTALLATION_PREFIX}${FILE}"

    if [[ -L ${FILE} ]]; then
      LINK_TARGET=$(realpath --canonicalize-existing --logical "${FILE}")
      [[ -e ${INSTALLATION_PREFIX}/${LINK_TARGET} ]] && continue
      echo "Copying symbolic link target '${LINK_TARGET}' of '${FILE}'"
      cp "${LINK_TARGET}" "${INSTALLATION_PREFIX}/${LINK_TARGET#/usr}"
    fi
  done < <(ldd "${PROGRAM}" | grep ' /lib')
done
