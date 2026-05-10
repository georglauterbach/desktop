# syntax=docker.io/docker/dockerfile:1

# We accept the following hadolint issues because
# this is a build container.
#
# hadolint global ignore=DL3002,DL3008,DL3009,DL3013,DL3059,DL4006

# cspell: disable

# Ubuntu 26.04
FROM docker.io/ubuntu@sha256:5e275723f82c67e387ba9e3c24baa0abdcb268917f276a0561c97bef9450d0b4
USER root

WORKDIR /src

ENV __INSTALLATION_PREFIX=/usr/local
ENV PATH=/root/.cargo/bin:/root/.local/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu

# -----------------------------------------------
# ----  Installation of General Packages  -------
# -----------------------------------------------

RUN apt-get update \
    && apt-get install --quiet --yes --no-install-recommends \
    bash-completion \
    ca-certificates \
    curl \
    file \
    openssl \
    tar \
    wget \
    xz-utils \
    \
    bison \
    build-essential \
    clang \
    cmake \
    flex \
    gcc \
    gettext \
    git \
    nasm \
    ninja-build \
    pkg-config \
    scdoc \
    \
    lua5.4 \
    liblua5.4-0 \
    liblua5.4-dev \
    \
    python3 \
    python3-docutils \
    python3-setuptools \
    python3-dev \
    \
    dbus \
    libdrm-dev \
    libffi-dev \
    libpam0g-dev \
    libpcre2-dev \
    libseccomp-dev \
    libssl-dev \
    libsystemd-dev \
    libudev-dev \
    shared-mime-info \
    systemd

# -----------------------------------------------
# ----  Python Setup  ---------------------------
# -----------------------------------------------

RUN curl -sSfL https://astral.sh/uv/install.sh | sh
RUN uv tool install meson==1.11.1

# -----------------------------------------------
# ----  Rust Setup  -----------------------------
# -----------------------------------------------

ENV __RUST_TOOLCHAIN_VERSION=1.95.0
RUN curl -sSfL https://sh.rustup.rs | sh -s -- -y --default-toolchain "${__RUST_TOOLCHAIN_VERSION}"
ENV CARGO_HOME=/src/rust/cargo/home
ENV RUSTUP_HOME=/src/rust/rustup/home
RUN rustup --quiet default "${__RUST_TOOLCHAIN_VERSION}"

# -----------------------------------------------
# ----  Miscellaneous Setup  --------------------
# -----------------------------------------------

RUN git config --global advice.detachedHead false

COPY build_scripts/log.sh /root/.local/bin/__log
COPY build_scripts/git_clone /root/.local/bin/git_clone

# -----------------------------------------------
# ----  Actual Build  ---------------------------
# -----------------------------------------------

# ? Wayland

RUN git_clone https://gitlab.freedesktop.org/wayland/wayland.git 1.25
RUN git_clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git 1.48

COPY build_scripts/build /root/.local/bin/build

RUN build wayland meson_ninja  \
    -D libraries=true          \
    -D scanner=true            \
    -D tests=false             \
    -D documentation=false     \
    -D dtd_validation=false

RUN build wayland-protocols meson_ninja -D tests=false

# ? generic dependencies

RUN git_clone https://gitlab.freedesktop.org/libinput/libinput.git 1.31.1
RUN git_clone https://gitlab.freedesktop.org/pixman/pixman.git pixman-0.46.4

COPY build_scripts/apt_install /root/.local/bin/apt_install

RUN apt_install libevdev-dev libmtdev-dev
RUN build libinput meson_ninja  \
    -D libwacom=false           \
    -D mtdev=false              \
    -D debug-gui=false          \
    -D tests=false              \
    -D documentation=false

RUN build pixman meson_ninja \
    -D tests=disabled        \
    -D demos=disabled

# ? Xorg

RUN git_clone https://gitlab.freedesktop.org/xorg/proto/xorgproto.git xorgproto-2025.1
RUN git_clone https://gitlab.freedesktop.org/xorg/xserver.git xwayland-24.1.10

RUN build xorgproto meson_ninja

RUN apt_install       \
    libx11-dev        \
    libxshmfence-dev  \
    x11-xkb-utils     \
    xutils-dev        \
    libgbm-dev        \
    libegl-dev        \
    libgl-dev         \
    libpixman-1-dev   \
    libxkbfile-dev    \
    libxkbfile-dev    \
    libxfont-dev      \
    libxcvt-dev       \
    libepoxy-dev      \
    mesa-common-dev   \
    libtirpc-dev      \
    libxcb-dri3-dev   \
    libxcb-xinput-dev \
    libxcb-sync-dev   \
    libxcb-damage0-dev
RUN build xserver meson_ninja \
    -D docs=false             \
    -D glamor=true            \
    -D dri3=true              \
    -D drm=true               \
    -D glx=true

# ? Sway

# TODO bump to 0.20.0 when https://github.com/wlrfx/scenefx/pull/184 is merged
RUN git_clone https://gitlab.freedesktop.org/wlroots/wlroots.git 0.19.3
RUN apt_install             \
    libxkbcommon-dev        \
    libvulkan-dev           \
    glslang-dev             \
    glslang-tools           \
    liblcms2-dev            \
    libseat-dev             \
    hwdata                  \
    libdisplay-info-dev     \
    libliftoff-dev          \
    libxcb-present-dev      \
    libxcb-composite0-dev   \
    libxcb-render-util0-dev \
    libxcb-shm0-dev         \
    libxcb-xfixes0-dev      \
    libxcb-xinput-dev       \
    libxcb-ewmh-dev         \
    libxcb-icccm4-dev       \
    libxcb-res0-dev libgles-dev
RUN build wlroots meson_ninja    \
    -D xwayland=enabled          \
    -D examples=false            \
    -D renderers=gles2,vulkan    \
    -D backends=drm,libinput,x11 \
    -D session=enabled           \
    -D color-management=enabled  \
    -D libliftoff=enabled

# TODO use new 0.5.x tag once released
RUN git_clone https://github.com/wlrfx/scenefx.git main
RUN build scenefx meson_ninja -D examples=false

RUN apt_install                \
    libjson-c-dev              \
    libcairo-dev               \
    libgdk-pixbuf-2.0-dev      \
    libgdk-pixbuf-xlib-2.0-dev \
    libpango1.0-dev
RUN git_clone https://github.com/WillPower3309/swayfx.git master
RUN build swayfx meson_ninja \
    -D default-wallpaper=false    \
    -D zsh-completions=false      \
    -D bash-completions=false     \
    -D fish-completions=false     \
    -D swaybar=false              \
    -D swaynag=false              \
    -D tray=enabled               \
    -D gdk-pixbuf=enabled         \
    -D man-pages=enabled          \
    -D sd-bus-provider=libsystemd

# ? Associates

# * firstly, run normal meson-ninja-based builds

RUN git_clone https://codeberg.org/tytan652/door-knocker.git main
RUN git_clone https://gitlab.freedesktop.org/emersion/grim.git v1.5.0
RUN git_clone https://github.com/davatorium/rofi.git next
RUN git_clone https://github.com/emersion/slurp.git v1.5.0
RUN git_clone https://github.com/ErikReider/SwayAudioIdleInhibit.git main
RUN git_clone https://github.com/swaywm/swaybg.git master
RUN git_clone https://github.com/swaywm/swayidle.git master
RUN git_clone https://github.com/swaywm/swaylock.git v1.8.5
RUN git_clone https://github.com/Alexays/Waybar.git 0.15.0
RUN git_clone https://github.com/ErikReider/SwayNotificationCenter.git main
RUN git_clone https://github.com/kennylevinsen/wlsunset.git master

RUN apt_install blueprint-compiler desktop-file-utils libgtk-4-dev libadwaita-1-dev
RUN build door-knocker           meson_ninja

RUN build grim                   meson_ninja
RUN build rofi                   meson_ninja -D xcb=disabled -D wayland=enabled
RUN build slurp                  meson_ninja

RUN apt_install systemd-dev libpulse-dev
RUN build SwayAudioIdleInhibit   meson_ninja -D logind-provider=systemd

RUN build swaybg                 meson_ninja
RUN build swayidle               meson_ninja
RUN build swaylock               meson_ninja -D pam=enabled

RUN apt_install            \
    gobject-introspection  \
    libdbusmenu-gtk3-dev   \
    libfmt-dev             \
    libgirepository1.0-dev \
    libgtk-3-dev           \
    libgtkmm-3.0-dev       \
    libinput-dev           \
    libjsoncpp-dev         \
    libmpdclient-dev       \
    libnl-3-dev            \
    libnl-genl-3-dev       \
    libpulse-dev           \
    libsigc++-2.0-dev      \
    libspdlog-dev          \
    scdoc                  \
    upower                 \
    libxkbregistry-dev     \
    libjack-dev            \
    libwireplumber-0.5-dev \
    libsndio-dev           \
    libupower-glib-dev
RUN build Waybar                 meson_ninja \
    -D libinput=enabled     \
    -D libnl=enabled        \
    -D libudev=enabled      \
    -D libevdev=enabled     \
    -D pipewire=enabled     \
    -D systemd=disabled     \
    -D dbusmenu-gtk=enabled \
    -D man-pages=enabled    \
    -D rfkill=enabled       \
    -D tests=disabled       \
    -D jack=enabled         \
    -D wireplumber=enabled  \
    -D cava=disabled        \
    -D login-proxy=true

RUN apt_install            \
    valac                  \
    sassc                  \
    libgtk-3-dev           \
    libjson-glib-dev       \
    libhandy-1-dev         \
    libgranite-7-dev       \
    libgtk-layer-shell-dev \
    libgtk4-layer-shell-dev
RUN build SwayNotificationCenter meson_ninja \
    -D systemd-service=false \
    -D zsh-completions=false \
    -D fish-completions=false

RUN build wlsunset               meson_ninja

# * next, run custom builds

RUN git_clone https://github.com/alacritty/alacritty.git v0.17.0
RUN git_clone https://github.com/zefr0x/ianny.git v2.1.3
RUN git_clone https://github.com/blurrycat/lightctl.git main
RUN git_clone https://github.com/Satty-org/Satty.git v0.20.1
RUN git_clone https://gitlab.com/w0lff/shikane.git master
RUN git_clone https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit.git master
RUN git_clone https://github.com/russelltg/wl-screenrec.git main
RUN git_clone https://github.com/AMNatty/wleave.git development
RUN git_clone https://github.com/nwg-piotr/nwg-look.git main

COPY build_scripts/custom_build /root/.local/bin/cb

RUN cb alacritty                     build_alacritty
RUN cb ianny                         build_ianny
RUN cb lightctl                      build_lightctl

RUN apt_install libgraphene-1.0-dev
RUN cb Satty                         build_satty

RUN cb shikane                       build_shikane

RUN cb wayland-pipewire-idle-inhibit build_wayland_pipewire_idle_inhibit

RUN apt_install libavutil-dev libavformat-dev libavfilter-dev libavdevice-dev
RUN cb wl-screenrec                  build_wl_screenrec

RUN apt_install librsvg2-dev
RUN cb wleave                        build_wleave

ENV __GO_TOOLCHAIN_VERSION=1.26.3
RUN wget --quiet -O go.tar.gz "https://go.dev/dl/go${__GO_TOOLCHAIN_VERSION}.linux-amd64.tar.gz" \
    && tar xf go.tar.gz -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin
RUN cb nwg-look                      build_nwg_look

COPY build_scripts/finalize_runtime_libs /root/.local/bin/finalize_runtime_libs
RUN finalize_runtime_libs

# ? final custom adjustments

# ! Take care when adjusting these paths;
# ! especially libc + ld-linux MUST remain in sync
# ! and MUST be the correct files from the correct place.
WORKDIR /usr/local/lib/x86_64-linux-gnu
RUN cp -r /lib/x86_64-linux-gnu/pulseaudio/ . \
    && ln -s pulseaudio/libpulsecommon-17.0.so libpulsecommon-17.0.so \
    && cp /usr/lib/x86_64-linux-gnu/libc.so.6 \
        /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 \
        /usr/lib/x86_64-linux-gnu/libdl.so.2 \
        /usr/lib/x86_64-linux-gnu/libpthread.so.0 \
        /usr/lib/x86_64-linux-gnu/libdisplay-info.so.3 \
        .
