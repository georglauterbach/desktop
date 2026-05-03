#! /bin/sh

set -e -u

meson setup build     \
  --reconfigure       \
  --backend=ninja     \
  --buildtype=release \
  --optimization=3    \
  --strip             \
  --warnlevel=0       \
  --prefix=/usr/local \
  \
  -D icons=true \
  -D gnome-shell=false \
  -D gtk=true \
  -D gtksourceview=true \
  -D metacity=false \
  -D sounds=false \
  -D sessions=false \
  -D cinnamon-shell=false \
  -D default=true \
  -D dark=true  \
  -D mate=false \
  -D mate-dark=false \
  -D ubuntu-unity=false \
  -D xfwm4=false \
  -D cinnamon=false \
  -D cinnamon-dark=false \
  -D accent-colors=

ninja -C build
ninja -C build render+symlink-icons-default
ninja -C build render+symlink-icons-dark

find build -type d -empty -delete
sudo ninja -C build install
