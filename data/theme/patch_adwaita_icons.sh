#! /bin/sh

# cSpell: ignore mimetypes Yaru

set -e -u

# Derive the Evergruv icon themes from the installed Adwaita: green folders
# for light, matching Yaru's default accent, yellow for dark. Each theme holds
# only the recolored folder icons and inherits everything else from Adwaita.
#
# Adwaita draws all folders in one family of blues. Computers, phones,
# add-ons and HTML files reuse a few of those blues as part of their artwork,
# so they are left alone.
#
# Usage: patch_adwaita_icons.sh [ADWAITA_DIR [ICONS_DIR]]

# Every blue becomes the Evergruv accent, mixed towards white or black by as
# much as the blue is lighter or darker than the folder body (#62a0ea), then
# grayed by as much as the blue is less saturated than the body. Keeping the
# blues' own lightness instead turns Evergruv's dark green into neon lime.
readonly LIGHT_RECOLOR='
  s/#62a0ea/#8DA101/gI; s/#438de6/#7E9001/gI; s/#afd4ff/#CCD58D/gI
  s/#c0d5ea/#BFC694/gI; s/#a4caee/#B6C16A/gI; s/#1a5fb4/#576302/gI
  s/#14498a/#424C01/gI; s/#1c71d8/#687601/gI; s/#428be2/#7A8B04/gI'
readonly DARK_RECOLOR='
  s/#62a0ea/#D8A657/gI; s/#438de6/#C1944E/gI; s/#afd4ff/#EDD7B3/gI
  s/#c0d5ea/#E2D3BA/gI; s/#a4caee/#E3C89D/gI; s/#1a5fb4/#856737/gI
  s/#14498a/#664F2A/gI; s/#1c71d8/#9F7A40/gI; s/#428be2/#BC914F/gI'

icons_build() {
  theme_dir="${ICONS_DIR}/${1}"
  rm -rf "${theme_dir}"

  for icon in                                                \
    "${ADWAITA_DIR}"/scalable/places/folder*.svg             \
    "${ADWAITA_DIR}"/scalable/places/network-workgroup.svg   \
    "${ADWAITA_DIR}"/scalable/places/user-bookmarks.svg      \
    "${ADWAITA_DIR}"/scalable/places/user-desktop.svg        \
    "${ADWAITA_DIR}"/scalable/places/user-home.svg           \
    "${ADWAITA_DIR}"/scalable/status/folder-open.svg         \
    "${ADWAITA_DIR}"/scalable/mimetypes/inode-directory.svg
  do
    target="${theme_dir}/${icon#"${ADWAITA_DIR}/"}"
    mkdir -p "${target%/*}"
    sed -e "${2}" "${icon}" > "${target}"

    # A release that redraws the folders in new blues would otherwise leave
    # them blue without anyone noticing.
    if cmp -s "${icon}" "${target}"
    then
      echo "ERROR: '${icon}' contains none of the known blues - update the color maps" >&2
      exit 1
    fi
  done

  cat > "${theme_dir}/index.theme" << EOF
[Icon Theme]
Name=${1}
Comment=Adwaita with Evergruv folders
Inherits=Adwaita,hicolor
Example=folder
Directories=scalable/mimetypes,scalable/places,scalable/status

[scalable/mimetypes]
Context=MimeTypes
Size=128
MinSize=8
MaxSize=512
Type=Scalable

[scalable/places]
Context=Places
Size=128
MinSize=8
MaxSize=512
Type=Scalable

[scalable/status]
Context=Status
Size=128
MinSize=8
MaxSize=512
Type=Scalable
EOF
}

readonly ADWAITA_DIR="${1:-/usr/share/icons/Adwaita}"
readonly ICONS_DIR="${2:-${XDG_DATA_HOME:-${HOME}/.local/share}/icons}"

icons_build Evergruv "${LIGHT_RECOLOR}"
icons_build Evergruv-dark "${DARK_RECOLOR}"
