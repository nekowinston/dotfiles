{
  config,
  lib,
  pkgs,
  ...
}:
let
  themeDir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
in
{
  config = lib.mkIf (config.isGraphical && pkgs.stdenv.isLinux) {
    home.pointerCursor = {
      name = "macOS-Monterey";
      package = pkgs.nur.repos.nekowinston.apple-cursor;
      size = 24;
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "WhiteSur";
        package = pkgs.whitesur-icon-theme;
      };
      theme = {
        name = "WhiteSur-Light";
        package = pkgs.whitesur-gtk-theme;
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
