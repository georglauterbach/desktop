# Rofi

To [build](https://github.com/davatorium/rofi/blob/next/INSTALL.md) [rofi](https://github.com/davatorium/rofi) from source, run the following commands from this directory:

```bash
# build
docker compose up --build

# check dynamic dependencies
ldd target/rofi/build/rofi | grep 'not found'

# copy binary to system
sudo cp target/rofi/build/rofi /usr/local/bin/
```
