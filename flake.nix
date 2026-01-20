{
  description = "@georglauterbach's desktop essentials";

  inputs = {
    packages-main = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    packages-nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "packages-main";
    };

    packages-zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "packages-main";
    };
  };

  outputs =
    inputs:
    let
      architecture = "x86_64-linux";
      packages = import inputs.packages-main {
        hostPlatform = inputs.packages-main.lib.mkDefault architecture;
        system = architecture;
        overlays = [ inputs.packages-nixgl.overlay ];
        config = {
          allowUnfree = true;
        };
      };

      zen = inputs.packages-zen-browser.packages.${architecture}.default;
    in
    {
      packages.${packages.stdenv.hostPlatform.system}.default = packages.buildEnv {
        name = "packages";
        # ? https://github.com/rcalixte/awesome-wayland?tab=readme-ov-file
        # ? https://search.nixos.org/packages?channel=25.11
        # ? https://mozilla.github.io/webrtc-landing/gum_test.html
        paths = with packages; [
          # Nix
          # -- https://github.com/nix-community/nixd
          nixd
          # -- https://github.com/NixOS/nixfmt
          nixfmt

          # Sway
          # -- https://github.com/nix-community/nixGL
          nixgl.nixGLIntel
          # -- https://github.com/WillPower3309/swayfx
          swayfx

          # TODO
          xwayland
          jq
          jaq
          wdisplays

          # bar
          # -- https://github.com/Alexays/Waybar
          waybar

          # launcher
          # -- https://github.com/davatorium/rofi
          rofi

          # notification center
          # -- https://github.com/ErikReider/SwayNotificationCenter
          swaynotificationcenter

          # screen management
          # -- https://gitlab.com/w0lff/shikane
          shikane
          # -- https://github.com/swaywm/swaybg
          swaybg
          # -- https://github.com/swaywm/swayidle
          swayidle
          # -- https://github.com/swaywm/swaylock
          swaylock
          # -- https://github.com/AMNatty/wleave
          wleave

          # TODO
          # TODO configure Waybar (remove current config)
          # -- https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit
          wayland-pipewire-idle-inhibit

          # screenshot
          # -- https://gitlab.freedesktop.org/emersion/grim
          grim
          # -- https://github.com/Satty-org/Satty
          satty
          # -- https://github.com/emersion/slurp
          slurp

          # terminal
          # -- https://github.com/alacritty/alacritty
          alacritty

          # miscellaneous
          # -- https://github.com/zefr0x/ianny
          # TODO add to Sway config
          ianny
          # -- https://github.com/pwmt/zathura
          # TODO add to Sway config
          zathura
          papers # TODO
          # -- https://github.com/russelltg/wl-screenrec
          wl-screenrec

          # -- https://github.com/artemsen/swayimg
          swayimg

          # -- https://codeberg.org/tytan652/door-knocker
          door-knocker

          zen
          teams-for-linux
          gnome-keyring
          seahorse

          dex

          kitty

          wireplumber
          pipewire
          rtkit

          xdg-desktop-portal
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk

          #vscode
          #flatpak
        ];
      };
    };
}
