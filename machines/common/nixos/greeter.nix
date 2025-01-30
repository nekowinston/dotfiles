{
  config,
  lib,
  pkgs,
  ...
}:
let
  isWindowManager = builtins.elem config.dotfiles.desktop [
    "hyprland"
    "sway"
    "swayfx"
  ];
in
{
  config = lib.mkIf isWindowManager {
    programs.regreet = {
      enable = true;

      font = {
        name = "IBM Plex Sans";
        size = 16;
        package = pkgs.ibm-plex;
      };

      cursorTheme = {
        name = "Yaru";
        package = pkgs.yaru-theme;
      };
      iconTheme = {
        name = "Yaru-dark";
        package = pkgs.yaru-theme;
      };
      theme = {
        name = "Yaru-dark";
        package = pkgs.yaru-theme;
      };

      settings.background = {
        path = ../../../home/wallpapers/blahaj-blue.png;
        fit = "Cover";
      };
    };

    security = {
      pam.services.greetd = {
        enableGnomeKeyring = true;
        u2fAuth = true;
      };
      polkit.enable = true;
      soteria.enable = true;
    };
    services.gnome.gnome-keyring.enable = true;
  };
}
