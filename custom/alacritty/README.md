# Alacritty

To [build](https://github.com/alacritty/alacritty/blob/master/INSTALL.md) [Alacritty](https://alacritty.org/) from source, run the following commands from this directory:

```bash
# build
docker compose up --build

# check dynamic dependencies
ldd target/alacritty/target/release/alacritty | grep 'not found'

# copy binary to system
sudo cp target/alacritty/target/release/alacritty /usr/local/bin/
```
