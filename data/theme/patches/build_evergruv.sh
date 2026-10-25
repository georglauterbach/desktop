#! /bin/sh

# cSpell: ignore buildtype warnlevel gtksourceview metacity
# cspell: ignore Yaru stylesheet gresource
# cSpell: ignore gsettings

set -e -u

# Build the Yaru theme
theme_build() {
  mkdir -p "${BUILD_PREFIX}"

  meson setup build            \
    --reconfigure              \
    --backend=ninja            \
    --buildtype=release        \
    --optimization=3           \
    --strip                    \
    --warnlevel=0              \
    --prefix="${BUILD_PREFIX}" \
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

  mkdir -p build/target/share/glib-2.0/schemas

  ninja -C build install
  find build -type d -empty -delete
}

# Yaru installs its GTK4 stylesheet inside `gtk.gresource` and leaves a `gtk.css`
# that only holds `@import url("resource:///...")`. GTK registers that resource
# bundle solely for the duration of the initial theme load, but re-parses the
# stylesheet whenever the system color scheme changes - the import then fails
# and every GTK4 app silently loses the entire theme (checked against GTK
# 4.24.1). Unpacking the bundle removes the import; the asset URLs inside
# the stylesheets are already relative to it.
theme_patch() {
  for theme in Yaru Yaru-dark; do
    theme_dir="${BUILD_PREFIX}/share/themes/${theme}/gtk-4.0"
    resource="${theme_dir}/gtk.gresource"

    if [ -f "${resource}" ]; then
      gresource list "${resource}" | while IFS= read -r entry; do
        target="${theme_dir}/${entry#"/com/ubuntu/themes/${theme}/4.0/"}"
        mkdir -p "$(dirname "${target}")"
        gresource extract "${resource}" "${entry}" | tee "${target}" >/dev/null
      done

      rm "${resource}"
    fi

    # Ensure gtk-dark.css is always a symbolic link to gtk.css;
    # for the light theme, gtk.css is the _only_ actual light
    # theme, so switching to light would otherwise keep a dark
    # theme independent of order of execution of
    # `gsettings set org.gnome.desktop.interface gtk-theme` and
    # `gsettings set org.gnome.desktop.interface color-scheme`.
    # It has to run after unpacking: `tee` follows the link, so
    # extracting the bundle's own gtk-dark.css would write it
    # straight into gtk.css.
    ln --symbolic --force --no-target-directory gtk.css "${theme_dir}/gtk-dark.css"

    # The theme is only safe across color scheme switches once nothing resolves
    # through the resource bundle anymore.
    if grep -rq 'resource:///' "${theme_dir}"; then
      echo "ERROR: ${theme_dir} still references the removed resource bundle" >&2
      exit 1
    fi
  done
}

theme_pack() {
  tar cJf "${BUILD_PREFIX}/Yaru.tar.xz" -C "${BUILD_PREFIX}/share" themes icons
}

readonly BUILD_PREFIX="${PWD}/build/target"

theme_build
theme_patch
theme_pack
