{
  config,
  pkgs,
  ...
}: rec {
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
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

  xdg = let
    themeDir = "${gtk.theme.package}/share/themes/${gtk.theme.name}";
  in {
    configFile."gtk-4.0/assets" = {
      source = "${themeDir}/gtk-4.0/assets";
      recursive = true;
    };
    configFile."gtk-4.0/gtk.css".source = "${themeDir}/gtk-4.0/gtk.css";
    configFile."gtk-4.0/gtk-dark.css".source = "${themeDir}/gtk-4.0/gtk-dark.css";
  };
}
