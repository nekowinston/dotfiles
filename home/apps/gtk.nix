{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  isWindowManager = builtins.elem osConfig.dotfiles.desktop [
    "hyprland"
    "sway"
    "swayfx"
  ];
  theme = {
    dark = "Yaru-dark";
    light = "Yaru";
  };
  dconfWrite = "${pkgs.dconf}/bin/dconf write";
  inherit (config.fonts.fontconfig) defaultFonts;
in
{
  config = lib.mkIf (config.isGraphical && pkgs.stdenv.isLinux) {
    home.pointerCursor = {
      name = theme.light;
      package = pkgs.yaru-theme;
      gtk.enable = true;
    };

    gtk = {
      enable = true;
      font.name = builtins.head defaultFonts.sansSerif;
      iconTheme = {
        name = theme.dark;
        package = pkgs.yaru-theme;
      };
      theme = {
        name = theme.dark;
        package = pkgs.yaru-theme;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

    services.darkman = lib.mkIf isWindowManager {
      lightModeScripts.gtk-theme = # bash
        ''
          ${dconfWrite} /org/gnome/desktop/interface/color-scheme "'prefer-light'"
          ${dconfWrite} /org/gnome/desktop/interface/gtk-theme "'${theme.light}'"
          ${dconfWrite} /org/gnome/desktop/interface/icon-theme "'${theme.light}'"
        '';
      darkModeScripts.gtk-theme = # bash
        ''
          ${dconfWrite} /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
          ${dconfWrite} /org/gnome/desktop/interface/gtk-theme "'${theme.dark}'"
          ${dconfWrite} /org/gnome/desktop/interface/icon-theme "'${theme.dark}'"
        '';
    };
  };
}
