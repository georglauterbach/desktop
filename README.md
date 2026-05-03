# My Linux Desktop

This repository contains the setup and configuration for my Linux desktop. It focuses on GUI applications; head over to [`georglauterbach/hermes`](https://github.com/georglauterbach/hermes) to find the TUI applications that I use on a daily basis. The color theme used is [Evergruv](https://github.com/georglauterbach/evergruv)..

| Property | Description |
| :------- | :---------- |
| Monospaced Font | JetBrainsMono Nerd Font & FiraCode Nerd Font (`./scripts/setup_fonts.sh`) |
| Normal Font     | Ubuntu Sans (`apt-get install --yes fonts-ubuntu`) |
| Icons           | [Nerd Fonts Icons](https://www.nerdfonts.com/cheat-sheet) |
| AsciiArt        | [Generated here](https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=test) |
| Theme           | `Evergruv-{Light,Dark}` (see [`gtk/`](./theme/) to symlink directories into `/usr/share/themes/`) |
| Configuration   | Files contained in [`home/`](./home/) go into `${HOME}`

## Programs

Essential programs are built from source in a container; other programs are installed via `apt`. To build the essential packages from source, use the scripts in [`programs/scripts/`](./programs/scripts/).

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

### Installed

1. Desktop File Opener: [dex](https://github.com/jceb/dex)
2. Keyring Daemon: [gnome-keyring](https://gitlab.gnome.org/GNOME/gnome-keyring)
3. Fallback Terminal: [kitty](https://github.com/kovidgoyal/kitty)
4. Image viewer: [swayimg](https://github.com/artemsen/swayimg)
5. Display Visualizer: [wdisplays](https://github.com/artizirk/wdisplays)
6. Document Viewer: [Zathura](https://pwmt.org/projects/zathura/)

