
# My Linux Desktop

| Property        | Description                                                                                |
| :-------------- | :----------------------------------------------------------------------------------------- |
| Distribution    | I assume Ubuntu 26.04, but other versions might also work                                  |
| Programs        | See the ["Programs" section below](#programs)                                              |
| (Icon) Theme    | See the ["Theme" section below](#theme)                                                    |
| Configuration   | Files contained in [`data/home/`](./data/home/) go into `${HOME}`                          |
| Fonts           | See `20-install_packages.sh` & `22-fonts.sh` in [`programs/scripts/`](./programs/scripts/) |
| Icon Font       | [Nerd Fonts Icons](https://www.nerdfonts.com/cheat-sheet)                                  |
| AsciiArt        | [patorjk](https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=A)                |

## Programs

### Installation

Essential programs are built from source in a container to have as much control over them as possible; other programs are [installed via `apt`](./programs/scripts/20-install_packages.sh). Perform the following steps for a system installation:

1. Install [Podman](https://podman.io/): `sudo apt-get --yes install podman`
2. Install [`lief-patchelf`](https://lief.re/blog/2025-07-13-patchelf/#download) (or [build](https://lief.re/doc/stable/tools/lief-patchelf/index.html#compilation) it from [here](https://github.com/lief-project/LIEF)):
    ```console
    $ curl -sSfL -o "${HOME}/.local/bin/lief-patchelf" \
        https://github.com/georglauterbach/desktop/releases/download/system-theme/lief-patchelf
    $ chmod +x "${HOME}/.local/bin/lief-patchelf"
    ```
3. Run the scripts in [`programs/scripts/`](./programs/scripts/) one after another in the [`programs/`](./programs/) directory
4. Configure SwayFX by adjusting `${HOME}/.config/sway/config` (e.g., to enable user configurations)
5. Configure [shikane](https://gitlab.com/w0lff/shikane) by running `shikanectl export default >"${HOME}/.config/shikane/config.toml" && systemctl --user restart shikane`
6. Copy [wleave's icons](https://github.com/AMNatty/wleave/tree/development/icons) to `/usr/local/share/wleave/icons/`

### Packages Built From Source

The following packages are built from source:

1. Wayland compositor: [SwayFX](https://github.com/WillPower3309/swayfx) with Xwayland support
2. Terminal: [Alacritty](https://github.com/alacritty/alacritty)
3. Bar: [Waybar](https://github.com/Alexays/Waybar)
4. Launcher: [rofi](https://github.com/davatorium/rofi)
5. Notifications: [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter)
6. Locking: [swayidle](https://github.com/swaywm/swayidle) & [swaylock](https://github.com/swaywm/swaylock)
7. Logout: [wleave](https://github.com/AMNatty/wleave)
8. Pauses: [ianny](https://github.com/zefr0x/ianny)
9. Inhibitors: [SwayAudioIdleInhibit](https://github.com/ErikReider/SwayAudioIdleInhibit) (and [wayland-pipewire-idle-inhibit](https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit) (unused))
10. Screenshots: [grim](https://gitlab.freedesktop.org/emersion/grim), [slurp](https://github.com/emersion/slurp) & [Satty](https://github.com/Satty-org/Satty)
11. Display configuration: [shikane](https://gitlab.com/w0lff/shikane)
12. Wallpaper: [awww](https://codeberg.org/LGFae/awww)
13. Gamma adjustments: [wlsunset](https://github.com/kennylevinsen/wlsunset)
14. Screen Brightness: [lightctl](https://github.com/blurrycat/lightctl)
15. Screen Recordings: [wl-screenrec](https://github.com/russelltg/wl-screenrec)
16. Portal Checker: [door-knocker](https://codeberg.org/tytan652/door-knocker)
17. Custom XDG Desktop Portal (incl. WLR portal): [xdg-desktop-portal](TODO) & [xdg-desktop-portal-wlr]()
17. GTK3 Settings Editor: [nwg-look](https://github.com/nwg-piotr/nwg-look)

## Theme

The colors are based on [Evergruv](https://github.com/georglauterbach/evergruv). The actual system theme (GTK etc.) is a patched version of [Yaru](https://github.com/ubuntu/yaru), the default Ubuntu GNOME theme. Yaru is a well-maintained, community-supported theme that has undergone extensive usage and testing. Hence, patching colors for this theme is a straightforward solution to getting a custom theme.

Files that were patched or added to the Yaru repository can be found in [`data/theme/patches/`](./data/theme/patches/). The generated files, after running [`data/theme/patches/build_evergruv.sh`](./data/theme/patches/build_evergruv.sh) in the patched Yaru repository, can be found [in a GitHub release](https://github.com/georglauterbach/desktop/releases/tag/system-theme). Download the archive and extract it via `tar xf Yaru.tar.xz -C "${HOME}"`. You can also use [`nwg-look`](https://github.com/nwg-piotr/nwg-look) to apply the theme; a pre-built binary can also be found in the mentioned [GitHub release](https://github.com/georglauterbach/desktop/releases/tag/system-theme).

## Licensing

Files in this repository are licensed under [GPLv3+](./LICENSE). Files in [`data/theme/`](./data/theme/) taken (and patched) from the [Yaru project](https://github.com/ubuntu/yaru) remain under their respective license.
