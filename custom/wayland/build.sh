#! /usr/bin/env bash

# cSpell: ignore Ddocumentation Drfkill Dwireplumber

set -eE -u -o pipefail
shopt -s inherit_errexit

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

  [[ -d ${DIR_NAME} ]] || git clone "http://${GIT_URI}.git"
  (
    cd "${DIR_NAME}"
    git fetch --prune --tags --force
    git checkout "${!GIT_REV_VAR_NAME:?}"
    "${@:-run_meson_ninja}"
  )
}

function run_meson_ninja() {
  meson setup build --reconfigure --prefix=/usr/local "${@}"
  ninja -C build install
}

cd /src

build_package gitlab.freedesktop.org/wayland/wayland run_meson_ninja '-Ddocumentation=false'
build_package gitlab.freedesktop.org/wayland/wayland-protocols

build_package gitlab.freedesktop.org/libinput/libinput
build_package gitlab.freedesktop.org/pixman/pixman

function build_libxcb_errors() {
  git submodule update --init --recursive
  ./autogen.sh
  ./configure
  make install
}
build_package gitlab.freedesktop.org/xorg/lib/libxcb-errors build_libxcb_errors

build_package gitlab.freedesktop.org/wlroots/wlroots
build_package github.com/swaywm/sway

#build_package github.com/wlrfx/scenefx
#build_package github.com/WillPower3309/swayfx

build_package github.com/davatorium/rofi
build_package github.com/ErikReider/SwayNotificationCenter
build_package github.com/Alexays/Waybar run_meson_ninja -Drfkill=enabled -Dwireplumber=enabled

rm -rf /out/*
cp -rf /usr/local/* /out/
