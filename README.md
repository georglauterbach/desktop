# My Linux Desktop

## About

This repository contains the setup for my Linux desktop. To run the setup, execute `bash install.sh`. To modify the installation, edit `distributions/ubuntu/<VERSION_ID>/install.sh` or `install.sh` directly.

> [!NOTE]
>
> To install the set of basic tools that I use on a daily basis, head over to [`georglauterbach/hermes`](https://github.com/georglauterbach/hermes); _hermes_ and these tools do not require a GUI.

## Software Stack

The following table lists the software I use for the latest version found in [`distributions`](./distributions/).

| Component | Name | Why? | More |
| :-------- | :--- | :------------------- |  :-- |
| Distribution | [Ubuntu](https://ubuntu.com/) | <ul><li>well-known & well-maintained</li><li>relatively up-to-date packages</li></ul> | To see which versions are supported, look into [`distributions/ubuntu/`](./distributions/ubuntu/). |
| Fallback [DE](https://wiki.archlinux.org/title/Desktop_environment) | [GNOME](https://www.gnome.org/) (minimal) | <ul><li>practical solution to installing basic software that the actual desktop later uses as well</li><li>allows switching in case main desktop is inaccessible</li></ul> | The package I install is `ubuntu-desktop-minimal`. |
| Wayland Compositor | [SwayFX](https://github.com/WillPower3309/swayfx) | <ul><li>Sway is minimal, solid & fast</li><li>SwayFX = Sway + "eye candy"</li></ul> | This package is [custom-built](./custom/swayfx/). You can disable the SwayFX-specific config easily when using plain Sway. |
| Status Bar | [Waybar](https://github.com/Alexays/Waybar) | <ul><li>minimal</li><li>easily yet highly customizable</li></ul> | This package is optionally [custom-built](./custom/waybar/) for the latest version. |
| Notification Daemon | [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter) | <ul><li>simple & solid</li></ul> | This package is optionally [custom-built](./custom/sway-notification-center/) for the latest version. |
| Application Launcher | [Rofi](https://github.com/davatorium/rofi) | <ul><li>minimal</li><li>easily yet highly customizable</li></ul> | This package is optionally [custom-built](./custom/rofi/) for the latest version. |
| Terminal | [Alacritty](https://github.com/alacritty/alacritty) | <ul><li>extremely fast & robust</li></ul> | |

## TODO

- GTK Themes: <https://github.com/georglauterbach/hermes/releases/tag/gtk-v0.1.0>
