FROM docker.packages.rsint.net/docker.io/ubuntu:25.10 AS base
USER root

ENV PATH=/root/.cargo/bin:/root/.local/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu

WORKDIR /src

RUN apt-get update \
    && apt-get install --quiet --yes --no-install-recommends \
    bash-completion \
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
    pipx \
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

RUN git config --global advice.detachedHead false
RUN pipx install meson
RUN curl -sSfL https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.92.0

ENV CARGO_HOME=/src/rust/cargo/home
ENV RUSTUP_HOME=/src/rust/rustup/home
RUN rustup --quiet default 1.92.0

ENV INSTALLATION_PREFIX=/usr/local

FROM base AS git-clone

COPY build_scripts/git_clone /root/.local/bin/git_clone

RUN git_clone https://gitlab.freedesktop.org/wayland/wayland.git 1.24
RUN git_clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git 1.47

RUN git_clone https://gitlab.freedesktop.org/libinput/libinput.git 1.30.1
RUN git_clone https://gitlab.freedesktop.org/pixman/pixman.git pixman-0.46.4

RUN git_clone https://gitlab.freedesktop.org/xorg/proto/xorgproto.git xorgproto-2025.1
RUN git_clone https://gitlab.freedesktop.org/xorg/xserver.git xwayland-24.1.9

RUN git_clone https://gitlab.freedesktop.org/wlroots/wlroots.git 0.19.2
RUN git_clone https://github.com/wlrfx/scenefx.git 0.4.1
RUN git_clone https://github.com/swaywm/sway.git 1.11
RUN git_clone https://github.com/WillPower3309/swayfx.git 0.5.3

FROM git-clone AS wayland

COPY build_scripts/build /root/.local/bin/build

RUN build wayland meson_ninja \
    -Dlibraries=true          \
    -Dscanner=true            \
    -Dtests=false             \
    -Ddocumentation=false     \
    -Ddtd_validation=false

RUN build wayland-protocols meson_ninja -Dtests=false

FROM wayland AS generic-dependencies

COPY build_scripts/apt_install /root/.local/bin/apt_install

RUN apt_install libevdev-dev libmtdev-dev
RUN build libinput meson_ninja \
    -Dlibwacom=false           \
    -Dmtdev=false              \
    -Ddebug-gui=false          \
    -Dtests=false              \
    -Ddocumentation=false

RUN build pixman meson_ninja -Dtests=disabled -Ddemos=disabled

FROM generic-dependencies AS xorg

RUN build xorgproto meson_ninja

RUN apt_install       \
    libx11-dev        \
    libxshmfence-dev  \
    x11-xkb-utils     \
    xutils-dev        \
    libxkbfile-dev    \
    libxkbfile-dev    \
    libxfont-dev      \
    libxcvt-dev       \
    libepoxy-dev      \
    mesa-common-dev   \
    libtirpc-dev      \
    libxcb-xinput-dev \
    libxcb-sync-dev   \
    libxcb-damage0-dev
RUN build xserver meson_ninja -Ddocs=false

COPY build_scripts/finalize_runtime_libs /root/.local/bin/finalize_runtime_libs
RUN finalize_runtime_libs

FROM xorg AS sway

RUN apt_install             \
    libxkbcommon-dev        \
    libgbm-dev              \
    libvulkan-dev           \
    glslang-dev             \
    glslang-tools           \
    liblcms2-dev            \
    libseat-dev             \
    hwdata                  \
    libdisplay-info-dev     \
    libliftoff-dev          \
    libxcb-dri3-dev         \
    libxcb-present-dev      \
    libxcb-composite0-dev   \
    libxcb-render-util0-dev \
    libxcb-shm0-dev         \
    libxcb-xfixes0-dev      \
    libxcb-xinput-dev       \
    libxcb-ewmh-dev         \
    libxcb-icccm4-dev       \
    libxcb-res0-dev libgles-dev
RUN build wlroots meson_ninja   \
    -Dxwayland=enabled          \
    -Dexamples=false            \
    -Drenderers=gles2,vulkan    \
    -Dbackends=drm,libinput,x11 \
    -Dsession=enabled           \
    -Dcolor-management=enabled  \
    -Dlibliftoff=enabled

RUN build scenefx meson_ninja -Dexamples=false

RUN apt_install                \
    libjson-c-dev              \
    libcairo-dev               \
    libgdk-pixbuf-2.0-dev      \
    libgdk-pixbuf-xlib-2.0-dev \
    libpango1.0-dev
    #RUN build sway meson_ninja
RUN build swayfx meson_ninja \
    -Ddefault-wallpaper=false    \
    -Dzsh-completions=false      \
    -Dbash-completions=false     \
    -Dfish-completions=false     \
    -Dswaybar=false              \
    -Dswaynag=false              \
    -Dtray=enabled               \
    -Dgdk-pixbuf=enabled         \
    -Dman-pages=enabled          \
    -Dsd-bus-provider=libsystemd

RUN finalize_runtime_libs

FROM sway AS associates

# ? Firstly, run normal meson-ninja-based builds

RUN git_clone https://codeberg.org/tytan652/door-knocker.git main
RUN git_clone https://gitlab.freedesktop.org/emersion/grim.git v1.5.0
RUN git_clone https://github.com/davatorium/rofi.git next
RUN git_clone https://github.com/emersion/slurp.git v1.5.0
RUN git_clone https://github.com/ErikReider/SwayAudioIdleInhibit.git main
RUN git_clone https://github.com/swaywm/swaybg.git master
RUN git_clone https://github.com/swaywm/swayidle.git master
RUN git_clone https://github.com/swaywm/swaylock.git v1.8.4
RUN git_clone https://github.com/Alexays/Waybar.git 0.14.0
RUN git_clone https://github.com/ErikReider/SwayNotificationCenter.git v0.12.4
RUN git_clone https://github.com/kennylevinsen/wlsunset.git master

RUN apt_install blueprint-compiler desktop-file-utils libgtk-4-dev libadwaita-1-dev
RUN build door-knocker           meson_ninja

RUN build grim                   meson_ninja
RUN build rofi                   meson_ninja -Dxcb=disabled -Dwayland=enabled
RUN build slurp                  meson_ninja

RUN apt_install systemd-dev libpulse-dev
RUN build SwayAudioIdleInhibit   meson_ninja -Dlogind-provider=systemd

RUN build swaybg                 meson_ninja
RUN build swayidle               meson_ninja
RUN build swaylock               meson_ninja -Dpam=enabled

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
    libwayland-dev         \
    scdoc                  \
    upower                 \
    libxkbregistry-dev     \
    libwireplumber-0.5-dev \
    libsndio-dev           \
    libupower-glib-dev
RUN build Waybar                 meson_ninja \
    -Dlibinput=enabled     \
    -Dlibnl=enabled        \
    -Dlibudev=enabled      \
    -Dlibevdev=enabled     \
    -Dpipewire=enabled     \
    -Dsystemd=disabled     \
    -Ddbusmenu-gtk=enabled \
    -Dman-pages=enabled    \
    -Drfkill=enabled       \
    -Dtests=disabled       \
    -Dwireplumber=enabled  \
    -Dcava=disabled        \
    -Dlogin-proxy=true

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
    -Dsystemd-service=false \
    -Dzsh-completions=false \
    -Dfish-completions=false

RUN build wlsunset               meson_ninja

# ? Next, run custom builds

RUN git_clone https://github.com/alacritty/alacritty.git v0.16.1
RUN git_clone https://github.com/zefr0x/ianny.git v2.1.3
RUN git_clone https://github.com/blurrycat/lightctl.git main
RUN git_clone https://github.com/Satty-org/Satty.git main
RUN git_clone https://gitlab.com/w0lff/shikane.git master
RUN git_clone https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit.git master
RUN git_clone https://github.com/russelltg/wl-screenrec.git main
RUN git_clone https://github.com/AMNatty/wleave.git development

COPY build_scripts/custom_build /root/.local/bin/cb

RUN cb alacritty                     build_alacritty
RUN cb ianny                         build_ianny
RUN cb lightctl                      build_lightctl

RUN apt_install libgraphene-1.0-dev
RUN cb Satty                         build_satty

RUN cb shikane                       build_shikane

RUN cb wayland-pipewire-idle-inhibit build_wayland_pipewire_idle_inhibit

RUN apt_install     \
    libavutil-dev   \
    libavformat-dev \
    libavfilter-dev \
    libavdevice-dev
RUN cb wl-screenrec                  build_wl_screenrec

RUN apt_install librsvg2-dev
RUN cb wleave                        build_wleave

RUN finalize_runtime_libs

FROM associates AS finish

RUN cd /usr/local/lib/x86_64-linux-gnu \
    && cp -r /lib/x86_64-linux-gnu/pulseaudio/ . \
    && mkdir --parents pulseaudio \
    && ln -s pulseaudio/libpulsecommon-17.0.so libpulsecommon-17.0.so

RUN mkdir --parents /usr/local/lib/stdc++/ \
    && cp /lib/x86_64-linux-gnu/libstdc++.so.6 /usr/local/lib/stdc++/
