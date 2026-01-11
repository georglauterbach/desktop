#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

readonly PREPARE_SOURCES='false'
readonly INSTALLATION_PREFIX='/usr/local'

# -----------------------------------------------
# ----  Common Build Functions  -----------------
# -----------------------------------------------

function prepare_sources() {
  local GIT_URI=${1:?URI for cloning is required}
  local GIT_REV=${2:?git revision is required}
  shift 2

  [[ ${PREPARE_SOURCES} == 'true' ]] || return 0

  local DIR_NAME=${GIT_URI/#*\/}
  DIR_NAME=${DIR_NAME%.git}

  [[ -d ${DIR_NAME} ]] || git clone "${GIT_URI}"
  (
    cd "${DIR_NAME}"
    git fetch --prune --tags --force
    git checkout "${GIT_REV}"
  )
}

function build() {
  echo -e "\n\033[1mBuilding '${1:?Directory to build in is required}'\033[0m\n"
  cd "${1}"
  shift 1
  "${@}"
  cd ..
}

function meson_ninja() {
  meson setup build --reconfigure --buildtype=release --prefix="${INSTALLATION_PREFIX}" "${@}"
  ninja -C build install
}

function setup_rust() {
  echo 'Setting up Rust'
  export CARGO_HOME='/src/rust/cargo/home' RUSTUP_HOME='/src/rust/rustup/home'
  readonly CARGO_HOME RUSTUP_HOME
  # shellcheck source=/dev/null
  source "${HOME}/.cargo/env"
  rustup --quiet default 1.92.0
}

function finalize_runtime_libs() {
  for PROGRAM in "${INSTALLATION_PREFIX}/bin/"*; do
    grep --quiet 'dynamically linked' <(file "${PROGRAM}") || continue
    strip --strip-all "${PROGRAM}"

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
}

# -----------------------------------------------
# ----  Prologue  -------------------------------
# -----------------------------------------------

echo 'Starting'
setup_rust
mkdir --parents "${INSTALLATION_PREFIX}/share/"{applications,man/{1,5,7}}
cd /src

apt-get install libxkbcommon-dev

# -----------------------------------------------
# ----  Base Libraries & Packages  --------------
# -----------------------------------------------

prepare_sources https://gitlab.freedesktop.org/wayland/wayland.git             1.24
prepare_sources https://gitlab.freedesktop.org/wayland/wayland-protocols.git   1.47

prepare_sources https://gitlab.freedesktop.org/xorg/proto/xorgproto.git        xorgproto-2025.1
prepare_sources https://gitlab.freedesktop.org/xorg/xserver.git                xwayland-24.1.9

prepare_sources https://gitlab.gnome.org/GNOME/glib.git                        2.87.1
prepare_sources https://gitlab.gnome.org/GNOME/gobject-introspection.git       1.86.0
prepare_sources https://github.com/libjxl/libjxl.git                          v0.11.1
prepare_sources https://gitlab.gnome.org/GNOME/gdk-pixbuf.git                  2.44.4
prepare_sources https://gitlab.freedesktop.org/cairo/cairo.git                 1.18.4
prepare_sources https://gitlab.gnome.org/GNOME/pango.git                       1.57.0
prepare_sources https://github.com/anholt/libepoxy.git                         1.5.10
prepare_sources https://github.com/ebassi/graphene.git                         1.10.8
#!CAUTION prepare_sources https://github.com/xkbcommon/libxkbcommon.git        xkbcommon-1.13.1

prepare_sources https://gitlab.freedesktop.org/libinput/libinput.git           1.30.1
prepare_sources https://gitlab.freedesktop.org/pixman/pixman.git        pixman-0.46.4
prepare_sources https://gitlab.freedesktop.org/pipewire/wireplumber.git        0.5.13

# -----------------------------------------------
# ----  GTK  ------------------------------------
# -----------------------------------------------

prepare_sources https://gitlab.gnome.org/GNOME/gtk.git                         4.21.4
prepare_sources https://gitlab.gnome.org/GNOME/libadwaita.git                  1.8.3
prepare_sources https://github.com/wmww/gtk4-layer-shell.git                  v1.3.0

# -----------------------------------------------
# ----  Sway & Companions  ----------------------
# -----------------------------------------------

prepare_sources https://gitlab.freedesktop.org/wlroots/wlroots.git             0.19.2
prepare_sources https://github.com/swaywm/sway.git                             1.11
prepare_sources https://github.com/swaywm/swaybg.git                           master
prepare_sources https://github.com/swaywm/swayidle.git                         master
prepare_sources https://github.com/swaywm/swaylock.git                        v1.8.4
prepare_sources https://github.com/ErikReider/SwayAudioIdleInhibit.git         main

prepare_sources https://github.com/wlrfx/scenefx.git                           0.4.1
prepare_sources https://github.com/WillPower3309/swayfx.git                    0.5.3

# -----------------------------------------------
# ----  Additional Programs  --------------------
# -----------------------------------------------

prepare_sources https://github.com/alacritty/alacritty.git                    v0.16.1
prepare_sources https://github.com/Alexays/Waybar.git                          0.14.0
prepare_sources https://github.com/AMNatty/wleave.git                          development
prepare_sources https://github.com/blurrycat/lightctl.git                      main
prepare_sources https://github.com/davatorium/rofi.git                         next
prepare_sources https://github.com/emersion/slurp.git                         v1.5.0
prepare_sources https://github.com/ErikReider/SwayNotificationCenter.git      v0.11.0
prepare_sources https://github.com/Satty-org/Satty.git                         main
prepare_sources https://gitlab.com/w0lff/shikane.git                           master
prepare_sources https://gitlab.freedesktop.org/emersion/grim.git              v1.5.0

# -----------------------------------------------
# ----  Build: Base Libraries & Packages  -------
# -----------------------------------------------

build wayland               meson_ninja -Ddocumentation=false
build wayland-protocols     meson_ninja

build libinput              meson_ninja
build pixman                meson_ninja
build wireplumber           meson_ninja

build xorgproto             meson_ninja
build xserver               meson_ninja

build glib                  meson_ninja -Dtests=false -Dsysprof=disabled -Dintrospection=disabled
build gobject-introspection meson_ninja -Dtests=false
build glib                  meson_ninja -Dtests=false -Dsysprof=disabled -Dintrospection=enabled

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
build cairo            meson_ninja -Dxcb=enabled -Dtests=disabled
build pango            meson_ninja
build libepoxy         meson_ninja
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

build wlroots              meson_ninja \
  -Dxwayland=enabled                   \
  -Dexamples=false                     \
  -Drenderers=gles2,vulkan             \
  -Dbackends=drm,libinput,x11          \
  -Dsession=enabled                    \
  -Dcolor-management=enabled           \
  -Dlibliftoff=enabled
build sway                 meson_ninja \
  -Dzsh-completions=false              \
  -Dfish-completions=false             \
  -Dswaybar=false                      \
  -Dswaynag=false                      \
  -Dman-pages=enabled                  \
  -Dsd-bus-provider=libsystemd
build swaybg               meson_ninja
build swayidle             meson_ninja
build swaylock             meson_ninja -Dpam=enabled
build SwayAudioIdleInhibit meson_ninja -Dlogind-provider=systemd
build scenefx              meson_ninja
build swayfx               meson_ninja

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
