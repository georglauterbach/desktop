# `SwayFX`

To build [SwayFX](https://github.com/WillPower3309/swayfx) from source, run the following commands:

```bash
docker compose up --build

while read -r FILE; do
  NEW_FILE=/usr/local${FILE#target}
  NEW_DIR=$(dirname "${NEW_FILE}")
  [[ -d ${NEW_DIR} ]] || sudo mkdir -p "${NEW_DIR}"

  echo "Creating '${NEW_FILE}'"
  sudo cp "${FILE}" "${NEW_FILE}"
done < <(command find target/ -type f)
```
