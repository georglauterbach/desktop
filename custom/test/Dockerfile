# syntax=docker.io/docker/dockerfile:1
#
# cSpell: disable

FROM docker.io/ubuntu:24.04

ENV PATH=/root/.local/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu

RUN FILE=/etc/apt/sources.list.d/ubuntu.sources \
    && . /etc/os-release                        \
    && echo 'Types: deb-src'                                            >>"${FILE}" \
    && echo 'URIs: http://de.archive.ubuntu.com/ubuntu/'                >>"${FILE}" \
    && echo 'Components: main restricted universe multiverse'           >>"${FILE}" \
    && echo 'Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg' >>"${FILE}" \
    && echo "Suites: ${VERSION_CODENAME} ${VERSION_CODENAME}-updates ${VERSION_CODENAME}-backports ${VERSION_CODENAME}-proposed" >>"${FILE}"

RUN apt-get update \
    && apt-get install --yes \
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
        python3-setuptools \
        python3-dev \
        pipx \
        \
        dbus \
        libdrm-dev \
        libudev-dev \
        libpam0g-dev \
        librsvg2-dev \
        libseccomp-dev \
        libssl-dev \
        libsystemd-dev

RUN git config --global advice.detachedHead false
RUN pipx install meson
RUN curl -sSfL https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.92.0

RUN apt-get update \
    && apt-get build-dep --yes \
        libinput-dev \
        libpixman-1-dev \
        xwayland \
        libglib2.0-dev \
        gobject-introspection \
        libjxl-dev \
        gdk-pixbuf \
        cairo \
        libepoxy-dev \
        libxkbcommon-dev \
        libgtk-4-dev \
        libadwaita-1-dev \
        sway \
        wireplumber \
        sway-notification-center \
    && apt-get install --yes \
        desktop-file-utils \
        glslang-dev \
        glslang-tools \
        hwdata \
        libdbusmenu-gtk3-dev \
        libegl1-mesa-dev \
        libgles2-mesa-dev \
        libgtkmm-3.0-dev \
        libgranite-dev \
        libheif-dev \
        libnl-3-dev \
        libnl-genl-3-dev \
        libpulse-dev \
        libxcb-composite0-dev \
        libxcb-ewmh-dev \
        libxcb-icccm4-dev \
        libxcb-res0-dev \
        libxcb-xfixes0-dev \
        libxkbcommon-dev \
        shared-mime-info
