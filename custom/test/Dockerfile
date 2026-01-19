# syntax=docker.packages.rsint.net/docker.io/docker/dockerfile:1
#
# cSpell: disable

FROM docker.packages.rsint.net/rs_common/rs-ubuntu:24.04
USER root

ENV PATH=/root/.local/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        bash-completion \
        curl \
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
        libudev-dev \
        libpam0g-dev \
        libpcre2-dev \
        libseccomp-dev \
        libssl-dev \
        libsystemd-dev \
        shared-mime-info \
        systemd

RUN git config --global advice.detachedHead false
RUN pipx install meson
RUN curl -sSfL https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.92.0

# RUN apt-get update \
#     && apt-get build-dep --yes \
#         libinput-dev \
#         libpixman-1-dev \
#         xwayland \
#         libglib2.0-dev \
#         gobject-introspection \
#         libjxl-dev \
#         gdk-pixbuf \
#         cairo \
#         libepoxy-dev \
#         libxkbcommon-dev \
#         libgtk-4-dev \
#         libadwaita-1-dev \
#         sway \
#         wireplumber \
#         sway-notification-center \
#     && apt-get install --yes \
#         librsvg2-dev \
#         desktop-file-utils \
#         glslang-dev \
#         glslang-tools \
#         hwdata \
#         libdbusmenu-gtk3-dev \
#         libegl1-mesa-dev \
#         libgles2-mesa-dev \
#         libgtkmm-3.0-dev \
#         libgranite-dev \
#         libheif-dev \
#         libnl-3-dev \
#         libnl-genl-3-dev \
#         libpulse-dev \
#         libxcb-composite0-dev \
#         libxcb-ewmh-dev \
#         libxcb-icccm4-dev \
#         libxcb-res0-dev \
#         libxcb-xfixes0-dev \
#         libxkbcommon-dev \
#         shared-mime-info
