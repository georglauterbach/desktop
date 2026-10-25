#! /bin/sh

set -e -u

readonly BUILD_PREFIX=build/output/

mkdir -p build/target

meson setup build     \
  --reconfigure       \
  --backend=ninja     \
  --buildtype=release \
  --optimization=3    \
  --strip             \
  --warnlevel=0       \
  --prefix=build/target \
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

# Yaru installs its GTK4 stylesheet inside `gtk.gresource` and leaves a
# `gtk.css` that only holds `@import url("resource:///...")`. GTK registers
# that resource bundle solely for the duration of the initial theme load, but
# re-parses the stylesheet whenever the system color scheme changes - the
# import then fails and every GTK4 app silently loses the entire theme
# (checked against GTK 4.24.1). Unpacking the bundle removes the import; the
# asset URLs inside the stylesheets are already relative to it.
for THEME in Yaru Yaru-dark; do
  THEME_DIR="/usr/local/share/themes/${THEME}/gtk-4.0"
  RESOURCE="${THEME_DIR}/gtk.gresource"
  [ -f "${RESOURCE}" ] || continue

  gresource list "${RESOURCE}" | while IFS= read -r ENTRY
  do
    TARGET="${THEME_DIR}/${ENTRY#"/com/ubuntu/themes/${THEME}/4.0/"}"
    sudo mkdir -p "$(dirname "${TARGET}")"
    gresource extract "${RESOURCE}" "${ENTRY}" | sudo tee "${TARGET}" >/dev/null
  done

  sudo rm "${RESOURCE}"

  # The theme is only safe across color scheme switches once nothing resolves
  # through the resource bundle anymore.
  if grep -rq 'resource:///' "${THEME_DIR}"
  then
    echo "ERROR: ${THEME_DIR} still references the removed resource bundle" >&2
    exit 1
  fi
done
