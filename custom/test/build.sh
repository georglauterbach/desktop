#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

readonly INSTALLATION_PREFIX='/usr/local'

# -----------------------------------------------
# ----  Functions  ------------------------------
# -----------------------------------------------

function log_important() {
  echo -e "\n\033[1m${*}\033[0m\n"
}

function prepare_sources() {
  local GIT_URI=${2:?URI for cloning is required}
  local GIT_REV=${3:?git revision is required}
  shift 2

  local DIR_NAME=${GIT_URI/#*\/}
  DIR_NAME=${DIR_NAME%.git}

  log_important "Preparing ${DIR_NAME} (${GIT_REV})"


  [[ -d ${DIR_NAME} ]] || git clone -quiet "${GIT_URI}"
  (
    cd "${DIR_NAME}"
    git fetch --quiet --prune --tags --force
    git checkout --quiet "${GIT_REV}"
  )
}

function build() {
  log_important "Building '${1:?Directory to build in is required}'"
  (
    cd "${1}"
    "${@:2}"
  )
}

function meson_ninja() {
  # cSpell: ignore warnlevel
  meson setup build     \
    --reconfigure       \
    --backend=ninja     \
    --buildtype=release \
    --warnlevel=0   \
    --prefix="${INSTALLATION_PREFIX}" "${@}"
  ninja -C build install
}

function setup_rust() {
  log_important 'Setting up Rust'
  export CARGO_HOME='/src/rust/cargo/home' RUSTUP_HOME='/src/rust/rustup/home'
  readonly CARGO_HOME RUSTUP_HOME
  # shellcheck source=/dev/null
  source "${HOME}/.cargo/env"
  rustup --quiet default 1.92.0
}

# -----------------------------------------------
# ----  Prologue  -------------------------------
# -----------------------------------------------

log_important 'Starting'
setup_rust
cd /src

# -----------------------------------------------
# ----  Base Libraries & Packages  --------------
# -----------------------------------------------

# ----  Wayland  --------------------------------
prepare_sources https://gitlab.freedesktop.org/wayland/wayland.git             1.24
prepare_sources https://gitlab.freedesktop.org/wayland/wayland-protocols.git   1.47

# ----  General Dependencies  -------------------
prepare_sources https://gitlab.freedesktop.org/libinput/libinput.git           1.30.1
prepare_sources https://gitlab.freedesktop.org/pixman/pixman.git        pixman-0.46.4
prepare_sources https://gitlab.freedesktop.org/pipewire/wireplumber.git        0.5.13

# ----  Xwayland  -------------------------------
prepare_sources https://gitlab.freedesktop.org/xorg/proto/xorgproto.git        xorgproto-2025.1
prepare_sources https://gitlab.freedesktop.org/xorg/xserver.git       xwayland-24.1.9

# ----  Sway  -----------------------------------
prepare_sources https://gitlab.freedesktop.org/wlroots/wlroots.git             0.19.2
prepare_sources https://github.com/wlrfx/scenefx.git                           0.4.1
#prepare_sources https://github.com/swaywm/sway.git                             1.11
prepare_sources https://github.com/WillPower3309/swayfx.git                    0.5.3

# ----  Additional Programs  --------------------

# ----  Bar
prepare_sources https://github.com/Alexays/Waybar.git                          0.14.0
# ----  Launcher
prepare_sources https://github.com/davatorium/rofi.git                         next
# ----  Notification center
prepare_sources https://github.com/ErikReider/SwayNotificationCenter.git      v0.11.0
# ----  Screen management
prepare_sources https://github.com/blurrycat/lightctl.git                      main
prepare_sources https://gitlab.com/w0lff/shikane.git                           master
prepare_sources https://github.com/ErikReider/SwayAudioIdleInhibit.git         main
prepare_sources https://github.com/swaywm/swaybg.git                           master
prepare_sources https://github.com/swaywm/swayidle.git                         master
prepare_sources https://github.com/swaywm/swaylock.git                        v1.8.4
prepare_sources https://github.com/AMNatty/wleave.git                          development
# ----  Screenshot
prepare_sources https://gitlab.freedesktop.org/emersion/grim.git              v1.5.0
prepare_sources https://github.com/Satty-org/Satty.git                         main
prepare_sources https://github.com/emersion/slurp.git                         v1.5.0
# ----  Terminal
prepare_sources https://github.com/alacritty/alacritty.git                    v0.16.1








# TODO
prepare_sources https://github.com/libjxl/libjxl.git                          v0.11.1
prepare_sources https://gitlab.gnome.org/GNOME/gdk-pixbuf.git                  2.44.4
prepare_sources https://github.com/ebassi/graphene.git                         1.10.8

prepare_sources https://gitlab.gnome.org/GNOME/gtk.git                         4.21.4
prepare_sources https://gitlab.gnome.org/GNOME/libadwaita.git                  1.8.3
prepare_sources https://github.com/wmww/gtk4-layer-shell.git                  v1.3.0

# -----------------------------------------------
# ----  Build: Base Libraries & Packages  -------
# -----------------------------------------------

# ----  Wayland  --------------------------------

build wayland meson_ninja \
  -Dlibraries=true        \
  -Dscanner=true          \
  -Dtests=false           \
  -Ddocumentation=false   \
  -Ddtd_validation=false

build wayland-protocols meson_ninja \
  -Dtests=false

apt-get install --yes --no-install-recommends

# ? libglib2.0-dev gobject-introspection libcairo2-dev libpango1.0-dev

libxkbcommon-dev

# ----  General Dependencies  -------------------

# APT: libevdev-dev libmtdev-dev
# ! required by SwayFX
build libinput meson_ninja \
  -Dlibwacom=false         \
  -Dmtdev=false            \
  -Ddebug-gui=false        \
  -Dtests=false            \
  -Ddocumentation=false

# ! required by wlroots
build pixman meson_ninja \
  -Dtests=disabled       \
  -Ddemos=disabled

# function build_glib() {
#   build glib meson_ninja     \
#     -Dsysprof=disabled       \
#     -Ddocumentation=false    \
#     -Dtests=false            \
#     -Dglib_debug=disabled "${@}"
# }

# build_glib -Dintrospection=disabled

# build gobject-introspection meson_ninja \
#   -Ddoctool=disabled                    \
#   -Dtests=false

# build_glib -Dintrospection=enabled

# # APT: liblzo2-dev libx11-xcb-dev
# build cairo meson_ninja \
#   -Ddwrite=enabled \
#   -Dfontconfig=enabled \
#   -Dfreetype=enabled \
#   -Dpng=enabled \
#   -Dxcb=enabled \
#   -Dxlib=enabled \
#   -Dxlib-xcb=enabled \
#   -Dzlib=enabled \
#   -Dtests=disabled \
#   -Dlzo=enabled

# # APT: libxft-dev
# build pango meson_ninja \
#   -Ddocumentation=false \
#   -Dman-pages=true \
#   -Dintrospection=enabled \
#   -Dbuild-testsuite=false \
#   -Dbuild-examples=false \
#   -Dfontconfig=enabled \
#   -Dsysprof=disabled \
#   -Dcairo=enabled \
#   -Dxft=enabled \
#   -Dfreetype=enabled

# # APT: libspa-0.2-dev libpipewire-0.3-dev
# build wireplumber meson_ninja   \
#   -Dintrospection=disabled      \
#   -Ddoc=disabled                \
#   -Dsystem-lua=true             \
#   -Dsystemd=enabled             \
#   -Dsystemd-system-service=true \
#   -Dtests=false                 \
#   -Ddbus-tests=false

# ----  Xwayland  -------------------------------

build xorgproto meson_ninja

# APT: libx11-dev libxshmfence-dev x11-xkb-utils libxkbfile-dev libxkbfile-dev libxfont-dev libxcvt-dev libepoxy-dev mesa-common-dev libtirpc-dev libxcb-xinput-dev libxcb-sync-dev libxcb-damage0-dev
build xserver meson_ninja -Ddocs=false

# ----  Sway  -----------------------------------

# APT: libxkbcommon-dev libgbm-dev libvulkan-dev glslang-dev glslang-tools liblcms2-dev libseat-dev hwdata libdisplay-info-dev libliftoff-dev libxcb-dri3-dev libxcb-present-dev libxcb-composite0-dev libxcb-render-util0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-xinput-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-res0-dev libgles-dev
build wlroots              meson_ninja \
  -Dxwayland=enabled                   \
  -Dexamples=false                     \
  -Drenderers=gles2,vulkan             \
  -Dbackends=drm,libinput,x11          \
  -Dsession=enabled                    \
  -Dcolor-management=enabled           \
  -Dlibliftoff=enabled

build scenefx meson_ninja \
  -Dexamples=false

# APT: libjson-c-dev libgdk-pixbuf-2.0-dev libgdk-pixbuf-xlib-2.0-dev
#build sway   meson_ninja    \
build swayfx meson_ninja    \
  -Ddefault-wallpaper=false \
  -Dzsh-completions=false   \
  -Dbash-completions=false  \
  -Dfish-completions=false  \
  -Dswaybar=false           \
  -Dswaynag=false           \
  -Dtray=enabled            \
  -Dgdk-pixbuf=enabled      \
  -Dman-pages=enabled       \
  -Dsd-bus-provider=libsystemd

















































function build_libjxl() {
  git submodule update --init --recursive --depth 1 --recommend-shallow
  export CC=clang CXX=clang++
  mkdir --parents build
  cd build
  cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..
  cmake --build . -- "-j$(nproc)"
  cmake --install .
  unset CC CXX
  cd ..
}
build libjxl build_libjxl

# -----------------------------------------------
# ----  Build: GTK  -----------------------------
# -----------------------------------------------

build gdk-pixbuf       meson_ninja \
  -Dpng=enabled \
  -Dtiff=enabled \
  -Djpeg=enabled \
  -Dgif=enabled \
  -Dglycin=disabled \
  -Dbuiltin_loaders=all \
  -Dintrospection=enabled \
  -Drelocatable=true \
  -Dtests=false \
  -Dinstalled_tests=false \
  -Dthumbnailer=disabled
build graphene         meson_ninja -Dtests=false -Dinstalled_tests=false
#!CAUTION build libxkbcommon     meson_ninja -Denable-x11=true

build gtk              meson_ninja \
  -Dx11-backend=true               \
  -Dwayland-backend=true           \
  -Dvulkan=enabled                 \
  -Dintrospection=enabled          \
  -Dbuild-demos=false              \
  -Dbuild-testsuite=false          \
  -Dbuild-examples=false           \
  -Dbuild-tests=false

build libadwaita       meson_ninja -Dvapi=false
build gtk4-layer-shell meson_ninja -Dvapi=false

# -----------------------------------------------
# ----  Build: Sway & Companions  ---------------
# -----------------------------------------------

build swaybg               meson_ninja
build swayidle             meson_ninja
build swaylock             meson_ninja -Dpam=enabled
build SwayAudioIdleInhibit meson_ninja -Dlogind-provider=systemd

# -----------------------------------------------
# ----  Build: Additional Programs  -------------
# -----------------------------------------------

function build_alacritty() {
  cargo build --release --no-default-features --features=wayland
  install -s -Dm755 target/release/alacritty -t "${INSTALLATION_PREFIX}/bin/"

  scdoc < extra/man/alacritty.1.scd          | gzip -c >"${INSTALLATION_PREFIX}/share/man/man1/alacritty.1.gz"
  scdoc < extra/man/alacritty-msg.1.scd      | gzip -c >"${INSTALLATION_PREFIX}/share/man/man1/alacritty-msg.1.gz"
  scdoc < extra/man/alacritty.5.scd          | gzip -c >"${INSTALLATION_PREFIX}/share/man/man5/alacritty.5.gz"
  scdoc < extra/man/alacritty-bindings.5.scd | gzip -c >"${INSTALLATION_PREFIX}/share/man/man5/alacritty-bindings.5.gz"
}

function build_wleave() {
  cargo build --release
  install -s -Dm755 target/release/wleave -t "${INSTALLATION_PREFIX}/bin/"
  # TODO also install icons
}

function build_lightctl() {
  cargo build --release
  install -s -Dm755 target/release/lightctl -t "${INSTALLATION_PREFIX}/bin/"
}

function build_satty() {
  cargo build --release
  install -s -Dm755 target/release/satty -t "${INSTALLATION_PREFIX}/bin/"

  mkdir --parents "${INSTALLATION_PREFIX}/share/"{icons/hicolor/scalable/apps,licenses/satty}

  install -Dm644 assets/satty.svg "${INSTALLATION_PREFIX}/share/icons/hicolor/scalable/apps/satty.svg"
  install -Dm644 satty.desktop    "${INSTALLATION_PREFIX}/share/applications/satty.desktop"

  install -Dm644 LICENSE ${INSTALLATION_PREFIX}/share/licenses/satty/LICENSE
}

function build_shikane() {
  cargo build --release

  install -s -Dm755 target/release/shikane    -t "${INSTALLATION_PREFIX}/bin/"
  install -s -Dm755 target/release/shikanectl -t "${INSTALLATION_PREFIX}/bin/"
}

build alacritty              build_alacritty
build Waybar                 meson_ninja \
  -Dlibinput=enabled                     \
  -Dlibnl=enabled                        \
  -Dlibudev=enabled                      \
  -Dlibevdev=enabled                     \
  -Dpipewire=enabled                     \
  -Dsystemd=disabled                     \
  -Ddbusmenu-gtk=enabled                 \
  -Dman-pages=enabled                    \
  -Drfkill=enabled                       \
  -Dtests=disabled                       \
  -Dwireplumber=enabled                  \
  -Dcava=disabled                        \
  -Dlogin-proxy=true
build wleave                 build_wleave
build lightctl               build_lightctl
build rofi                   meson_ninja -Dxcb=disabled -Dwayland=enabled
build slurp                  meson_ninja
build SwayNotificationCenter meson_ninja
build Satty                  build_satty
build shikane                build_shikane
build grim                   meson_ninja

# -----------------------------------------------
# ----  Epilogue  -------------------------------
# -----------------------------------------------

finalize_runtime_libs
