# Waybar

To [build](https://github.com/Alexays/Waybar?tab=readme-ov-file#building-from-source) [Waybar](https://github.com/Alexays/Waybar) from source, run the following commands from this directory:

```bash
# build
docker compose up --build

# check dynamic dependencies and copy them from a running container if required
ldd target/Waybar/build/waybar | grep 'not found'

# copy binary to system
sudo cp target/Waybar/build/waybar /usr/local/bin/
```
