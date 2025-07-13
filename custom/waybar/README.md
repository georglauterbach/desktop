# Waybar

To [build](https://github.com/Alexays/Waybar?tab=readme-ov-file#building-from-source) [Waybar](https://github.com/Alexays/Waybar) from source, run the following commands from this directory:

```bash
docker compose up --build
sudo bash

while read -r FILE; do
  NEW_FILE=/usr/local${FILE#target/.prefix}
  NEW_DIR=$(dirname "${NEW_FILE}")
  [[ -d ${NEW_DIR} ]] || mkdir -p "${NEW_DIR}"

  echo "Creating '${NEW_FILE}'"
  cp "${FILE}" "${NEW_FILE}"
done < <(command find target/.prefix -type f)
```
