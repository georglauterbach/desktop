sudo mkdir -p $WLD/share/X11/xkb/rules
[sudo] password for lauter_g:
➜ ln -s /usr/share/X11/xkb/rules/evdev $WLD/share/X11/xkb/rules/
ln: failed to create symbolic link '/usr/local/share/X11/xkb/rules/evdev': Permission denied
➜ sudo ln -s /usr/share/X11/xkb/rules/evdev $WLD/share/X11/xkb/rules/
➜ sudo ln -s /usr/bin/xkbcomp $WLD/bin/xkbcomp
