# The Latest `rofi`

To [build](https://github.com/davatorium/rofi/blob/next/INSTALL.md) the latest [rofi](https://github.com/davatorium/rofi) for Wayland from source, run the following commands:

```bash
mkdir build_output
docker compose up --build -d # --force-recreate
docker exec -ti rofi-builder bash

meson setup ../build/ -Dxcb=disabled
ninja -C ../build
exit

docker compose down
```

You can then find the binary `rofi` in `build/`.
