# My Linux Desktop

| Property        | Description                                                                 |
| :-------------- | :-------------------------------------------------------------------------- |
| Programs        | See the ["Programs" section below](#programs)                               |
| (Icon) Theme    | See the ["Theme" section below](#theme)                                     |
| Configuration   | Files contained in [`home/`](./home/) go into `${HOME}`                     |
| Normal Font     | Ubuntu Sans (`apt-get install --yes fonts-ubuntu`)                          |
| Monospaced Font | JetBrainsMono Nerd Font & FiraCode Nerd Font (`./scripts/setup_fonts.sh`)   |
| Icon Font       | [Nerd Fonts Icons](https://www.nerdfonts.com/cheat-sheet)                   |
| AsciiArt        | [patorjk](https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=A) |

## Programs

Essential programs are built from source in a container to have as much control over them as possible; other programs are installed via `apt`. To build the essential packages from source, use the scripts in [`programs/scripts/`](./programs/scripts/).

### Built from Source

The following packages are built or installed:

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
12. Wallpaper: [swaybg](https://github.com/swaywm/swaybg)
13. Gamma adjustments: [wlsunset](https://github.com/kennylevinsen/wlsunset)
14. Screen Brightness: [lightctl](https://github.com/blurrycat/lightctl)
15. Screen Recordings: [wl-screenrec](https://github.com/russelltg/wl-screenrec)
16. Portal Checker: [door-knocker](https://codeberg.org/tytan652/door-knocker)
17. GTK3 Settings Editor: [nwg-look](https://github.com/nwg-piotr/nwg-look)

### Installed

1. Desktop File Opener: [dex](https://github.com/jceb/dex)
2. Keyring Daemon: [gnome-keyring](https://gitlab.gnome.org/GNOME/gnome-keyring)
3. Fallback Terminal: [kitty](https://github.com/kovidgoyal/kitty)
4. Image viewer: [swayimg](https://github.com/artemsen/swayimg)
5. Display Visualizer: [wdisplays](https://github.com/artizirk/wdisplays)
6. Document Viewer: [Zathura](https://pwmt.org/projects/zathura/)

## Theme

The colors are based on [Evergruv](https://github.com/georglauterbach/evergruv). The actual system theme (GTK etc.) is a patched version of [Yaru](https://github.com/ubuntu/yaru), the default Ubuntu GNOME theme. Yaru is a well-maintained, community-supported theme that has undergone extensive usage and testing. Hence, patching colors for this theme is a straightforward solution to getting a custom theme.

Files that were patched or added to the Yaru repository can be found in [`theme/patches/`](./theme/patches/). The generated files, after running [`theme/patches/build_evergruv.sh`](./theme/patches/build_evergruv.sh) in the patched Yaru repository, can be found [in a GitHub release](https://github.com/georglauterbach/desktop/releases/tag/system-theme). Download the archive and extract it via `tar xf Yaru.tar.xz -C "${HOME}"`. You can also use [`nwg-look`](https://github.com/nwg-piotr/nwg-look) to apply the theme; a pre-built binary can also be found in the mentioned [GitHub release](https://github.com/georglauterbach/desktop/releases/tag/system-theme).



## Licensing

Files in this repository are licensed under [GPLv3+](./LICENSE). Files in [`theme/`](./theme/) taken (and patched) from the [Yaru project](https://github.com/ubuntu/yaru) remain under their respective license.
