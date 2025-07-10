# My Linux Desktop

## About

This repository contains the setup for my Linux desktop. To install the set of basic tools that I use on a daily basis, head over to [`georglauterbach/hermes`](https://github.com/georglauterbach/hermes); _hermes_ and the tools _hermes_ installs do not require a GUI.

To run the setup, execute `bash install.sh`.

## Software Stack

The desktop is based on Ubuntu. To see which versions are supported, look into [`distributions/ubuntu/`](./distributions/ubuntu/). A practical solution to installing basic software that my actual desktop later uses as well is installing `ubuntu-desktop-minimal`. This has the additional upside of allowing you to switch to GNOME in case your main desktop is inaccessible or does not work as expected.

The desktop itself is provided by [`swaywm/sway`](https://github.com/swaywm/sway), a minimal Wayland compositor. Additionally, other (support) programs are required for a fully functioning desktop. You can find these programs by looking for the `PACKAGES` array in the `install.sh` scripts in [`distributions/ubuntu/*/`](./distributions/ubuntu/).

The following table shows a list of the most important graphical programs that I install:

| Name                                                | Description          |
| :-------------------------------------------------- | :------------------- |
| [Waybar](https://github.com/Alexays/Waybar)         | Wayland bar          |
| [Alacritty](https://github.com/alacritty/alacritty) | Terminal             |
| [rofi](https://github.com/davatorium/rofi)          | Application launcher |

## TODO

- GTK Themes: <https://github.com/georglauterbach/hermes/releases/tag/gtk-v0.1.0>
- custom rofi
