# syntax=docker.io/docker/dockerfile:1

FROM ubuntu:25.04

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]

ARG WLROOTSVERSION=0.19.0
ARG WLROOTSLIBVERSION=0.19
ARG SWAYFXVERSION=0.5.3
ARG SCENEFXVERSION=0.4.1
ARG SCENEFXLIBVERSION=0.4

ENV LANG C.UTF-8

RUN <<EOF
  PACKAGES=(
    build-essential
    cmake
    cdbs
    devscripts
    equivs
    meson
    wayland-protocols
    libwayland-dev
    libwayland-bin
    libwayland-client0
    libdrm-dev
    libxkbcommon-dev
    libudev-dev
    hwdata
    libseat-dev
    libgles-dev
    libavutil-dev
    libavcodec-dev
    libavformat-dev
    libgbm-dev
    xwayland
    libxcb-composite0-dev
    libxcb-icccm4-dev
    libxcb-res0-dev
    libxcb-errors-dev
    libinput-dev
    libxcb-present-dev
    libxcb-render-util0-dev
    libxcb-xinput-dev
    glslang-tools
    glslang-dev
    libpcre2-dev
    libjson-c-dev
    libgdk-pixbuf-2.0-dev
    libsystemd-dev
    scdoc
    bash-completion
    libpango1.0-dev
    libcairo2-dev
    libxcb-ewmh-dev
    libdisplay-info-dev
    libliftoff-dev
    liblcms2-dev
    libvulkan-dev
    wget
    bash
    git
    ca-certificates
  )

  apt-get --yes update
  apt-get --yes install --no-install-recommends "${PACKAGES[@]}"
  rm -rf /var/lib/apt/lists/*
EOF

WORKDIR /build

RUN <<EOF
  wget "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/${WLROOTSVERSION}/wlroots-${WLROOTSVERSION}.tar.gz"
  tar -xf "wlroots-${WLROOTSVERSION}.tar.gz"
  rm "wlroots-${WLROOTSVERSION}.tar.gz"
EOF

RUN <<EOF
  wget "https://github.com/WillPower3309/swayfx/archive/refs/tags/${SWAYFXVERSION}.tar.gz"
  tar -xf "${SWAYFXVERSION}.tar.gz"
  rm "${SWAYFXVERSION}.tar.gz"
EOF

RUN <<EOF
  wget "https://github.com/wlrfx/scenefx/archive/refs/tags/${SCENEFXVERSION}.tar.gz"
  tar -xf "${SCENEFXVERSION}.tar.gz"
  rm "${SCENEFXVERSION}.tar.gz"
EOF

COPY build.sh .
RUN chmod 755 build.sh

ENTRYPOINT ["/build/build.sh"]
