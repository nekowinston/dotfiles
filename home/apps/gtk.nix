{
  config,
  lib,
  pkgs,
  ...
}: let
  themeDir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
in {
  config = lib.mkIf (config.isGraphical && pkgs.stdenv.isLinux) {
    home.pointerCursor = {
      name = "macOS-Monterey";
      package = pkgs.nur.repos.nekowinston.apple-cursor;
      size = 24;
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "pink";
        };
      };
      theme = {
        name = "Catppuccin-Mocha-Compact-Pink-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["pink"];
          variant = "mocha";
          size = "compact";
        };
      };
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
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

    xdg = {
      configFile."gtk-4.0/assets" = {
        source = "${themeDir}/gtk-4.0/assets";
        recursive = true;
      };
      configFile."gtk-4.0/gtk.css".source = "${themeDir}/gtk-4.0/gtk.css";
      configFile."gtk-4.0/gtk-dark.css".source = "${themeDir}/gtk-4.0/gtk-dark.css";
    };
  };
}
