#! /usr/bin/env bash

# This script is only for backward-compatibility to Ubuntu 24.04

function __root_setup() {
  readonly PACKAGES=(ubuntu-desktop-minimal)

  apt-get --yes update
  apt-get --yes install --no-install-recommends --no-install-suggests "${PACKAGES[@]}"
}
