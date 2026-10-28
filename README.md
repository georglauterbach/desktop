
# My Linux Desktop

| Property      | Description                                                                   |
| :------------ | :---------------------------------------------------------------------------- |
| Distribution  | Ubuntu <= 26.10 and >= 26.04 with GTK4 >= 4.24                                |
| Programs      | See the ["Programs" section below](#programs)                                 |
| Theme         | See the ["Theme" section below](#theme)                                       |
| Configuration | Files contained in [`data/home/`](data/home/) go into `${HOME}`               |
| Fonts         | See [`20-install_packages.sh`](programs/scripts/20-install_packages.sh), [`22-fonts.sh`](programs/scripts/22-fonts.sh), and [Nerd Fonts Icons](https://www.nerdfonts.com/cheat-sheet) |
| AsciiArt      | [patorjk](https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=ART) |

## Programs

### Installation

Essential programs are built from source in a container, patched to use the correct shared objects and then linked into `/usr/local/` (all without linking the shared objects into `/usr/local/`). Other programs are [installed via `apt`](programs/scripts/20-install_packages.sh).

Perform the following steps for a system installation:
1. Install [Podman](https://podman.io/): `sudo apt-get --yes install podman`
2. Install [`lief-patchelf`](https://lief.re/blog/2025-07-13-patchelf/#download) (or [build](https://lief.re/doc/stable/tools/lief-patchelf/index.html#compilation) it from [here](https://github.com/lief-project/LIEF)):
    ```console
    $ curl -sSfL -o "${HOME}/.local/bin/lief-patchelf" \
        https://github.com/georglauterbach/desktop/releases/download/system-theme/lief-patchelf
    $ chmod +x "${HOME}/.local/bin/lief-patchelf"
    ```
3. Run the scripts in [`programs/scripts/`](./programs/scripts/) one after another in the [`programs/`](./programs/) directory, either manually or with [`just`](https://github.com/casey/just)
4. Configure SwayFX by adjusting `${HOME}/.config/sway/config` (e.g., enable user configuration includes)
5. Configure [shikane](https://gitlab.com/w0lff/shikane) by running `shikanectl export default >"${HOME}/.config/shikane/config.toml" && systemctl --user restart shikane`
6. Copy [wleave's icons](https://github.com/AMNatty/wleave/tree/development/icons) to `/usr/local/share/wleave/icons/`

### Packages Built From Source

The following packages are built from source:

1. Wayland compositor: [SwayFX](https://github.com/WillPower3309/swayfx) (with Xwayland support)
2. Terminal: [Alacritty](https://github.com/alacritty/alacritty) (see [vtdn.dev](https://vtdn.dev/) for terminal capabilities)
3. Bar: [Ironbar](https://github.com/JakeStanger/ironbar)
4. Launcher: [rofi](https://github.com/davatorium/rofi)
5. Notifications: [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter)
6. Locking: [swayidle](https://github.com/swaywm/swayidle) & [swaylock](https://github.com/swaywm/swaylock)
7. Logout: [wleave](https://github.com/AMNatty/wleave)
8. Pauses: [ianny](https://github.com/zefr0x/ianny)
9. Inhibitors: [wayland-pipewire-idle-inhibit](https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit)
10. Screenshots: [grim](https://gitlab.freedesktop.org/emersion/grim), [slurp](https://github.com/emersion/slurp) & [Satty](https://github.com/Satty-org/Satty)
11. Display configuration: [shikane](https://gitlab.com/w0lff/shikane)
12. Wallpaper: [awww](https://codeberg.org/LGFae/awww)
13. Gamma adjustments: [wlsunset](https://github.com/kennylevinsen/wlsunset)
14. Screen Brightness: [lightctl](https://github.com/blurrycat/lightctl)
15. Screen Recordings: [wl-screenrec](https://github.com/russelltg/wl-screenrec)
16. Portal Checker: [door-knocker](https://codeberg.org/tytan652/door-knocker)
17. Custom XDG Desktop Portals: [xdg-desktop-portal](https://github.com/flatpak/xdg-desktop-portal) & [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr)
18. GTK3 Settings Editor: [nwg-look](https://github.com/nwg-piotr/nwg-look)

## Theme

The colors are based on [Evergruv](https://github.com/georglauterbach/evergruv). The actual system theme is a patched version of [libadwaita](https://gitlab.gnome.org/GNOME/libadwaita) (a GNOME platform library), a patched version of which is built in the [container](#installation). Recoloring libadwaita rather than a third-party theme keeps the upstream design language, and it is the only thing libadwaita apps actually read - they ignore `gtk-theme-name` and draw from the stylesheet compiled into the library.

Since libadwaita is bundled, only the bundled programs from the container that use libadwaita load it. A process can only load one glibc and one GTK, so host apps keep loading the host's stock libadwaita. They, and Flatpak apps, are recolored by [`data/home/.config/gtk-4.0/gtk.css`](./data/home/.config/gtk-4.0/gtk.css) instead, which follows the system color scheme and requires GTK 4.20 or newer. libadwaita is GTK4 only, so GTK3 apps are not covered.

GTK4 apps that do not use libadwaita fall back to GTK's built-in Adwaita, which the stylesheets above cannot recolor. They need the patched stylesheet as a theme directory instead, which the container installs as `Evergruv` into `/usr/local/share/themes/`. It requires GTK 4.23.1 or newer.

The `Evergruv` and `Evergruv-dark` icon themes are Adwaita with green and yellow folders, respectively, and inherit all other icons from Adwaita. They are derived from the installed Adwaita icons on the host itself by running [`data/theme/patch_adwaita_icons.sh`](./data/theme/patch_adwaita_icons.sh), which writes them to `~/.local/share/icons/`.

## Licensing

Files in this repository are licensed under [GPLv3+](./LICENSE). Files in [`programs/patches/libadwaita/`](./programs/patches/libadwaita/) taken (and patched) from the [libadwaita project](https://gitlab.gnome.org/GNOME/libadwaita) remain under their respective license.
