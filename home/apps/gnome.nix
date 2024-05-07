{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  primary-color = "#161321";
  secondary-color = "#161321";
  wallpaper-uri = "file://${../wallpapers/dhm_1610.png}";
in
{
  config =
    lib.mkIf (config.isGraphical && pkgs.stdenv.isLinux && (osConfig.dotfiles.desktop == "gnome"))
      {
        home.packages = with pkgs.gnomeExtensions; [
          appindicator
          blur-my-shell
          mullvad-indicator
          native-window-placement
          noannoyance-fork
          pop-shell
          user-themes
          pkgs.pop-launcher
        ];

        dconf.settings = with lib.hm.gvariant; {
          # input
          "org/gnome/desktop/wm/preferences" = {
            resize-with-right-button = true;
          };
          "org/gnome/desktop/input-sources" = {
            sources = [
              (mkTuple [
                "xkb"
                "us"
              ])
            ];
            xkb-options = [ "caps:ctrl_modifier" ];
          };

          # rice
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [
              "appindicatorsupport@rgcjonas.gmail.com"
              "blur-my-shell@aunetx"
              "drive-menu@gnome-shell-extensions.gcampax.github.com"
              "mullvadindicator@pobega.github.com"
              "noannoyance-fork@vrba.dev"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
            ];
            favorite-apps = [
              "org.gnome.Nautilus.desktop"
              "chromium-browser.desktop"
              "org.wezfurlong.wezterm.desktop"
            ];
          };
          "org/gnome/shell/extensions/user-theme" = {
            name = "WhiteSur-Light";
          };

          # wallpaper
          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = wallpaper-uri;
            picture-uri-dark = wallpaper-uri;
            inherit primary-color secondary-color;
          };
          "org/gnome/desktop/screensaver" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = wallpaper-uri;
            inherit primary-color secondary-color;
          };
        };
      };
}
