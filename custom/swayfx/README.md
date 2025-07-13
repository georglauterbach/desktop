# `SwayFX`

To build [SwayFX](https://github.com/WillPower3309/swayfx) from source, run the following commands:

```bash
docker compose up --build
sudo bash

while read -r FILE; do
  NEW_FILE=/usr/local${FILE#target}
  NEW_DIR=$(dirname "${NEW_FILE}")
  [[ -d ${NEW_DIR} ]] || mkdir -p "${NEW_DIR}"

  echo "Creating '${NEW_FILE}'"
  cp "${FILE}" "${NEW_FILE}"
done < <(command find target/ -type f)

cat >/usr/share/wayland-sessions/swayfx.desktop <<"EOF"
[Desktop Entry]
Name=SwayFX
Comment=An i3-compatible Wayland compositor with eye candy
Exec=/usr/local/bin/swayfx
Type=Application
DesktopNames=swayfx
EOF
```
