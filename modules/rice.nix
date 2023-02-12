{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  gtk = lib.mkIf isLinux {
    enable = true;

    cursorTheme = {
      name = "Catppuccin-Mocha-Cursors";
      package = pkgs.catppuccin-cursors.mochaPink;
    };
    iconTheme = {
      package = pkgs.papirus-folders-catppuccin.override {
        flavour = "mocha";
        accent = "pink";
      };
      name = "Papirus-Dark";
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.unstable.catppuccin-gtk;
    };

    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
  };

  programs.rofi = lib.mkIf isLinux {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Berkeley Mono 14";
    extraConfig.icon-theme = "Papirus-Dark";
    terminal = "${lib.getExe pkgs.wezterm}";
    theme = ./rofi/theme.rasi;
  };
}
