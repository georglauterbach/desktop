# The Latest `rofi`

To [build](https://github.com/davatorium/rofi/blob/next/INSTALL.md) the latest [rofi](https://github.com/davatorium/rofi) from source, run the following commands:

```bash
mkdir build
docker compose up --build
cp target/build/rofi /usr/local/bin/rofi
```

You can then find the binary `rofi` in `build/`.
