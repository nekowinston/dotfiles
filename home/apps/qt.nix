{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (config.fonts.fontconfig) defaultFonts;
  sansSerif = builtins.head defaultFonts.sansSerif;
  monospace = builtins.head defaultFonts.monospace;

  isWindowManager = builtins.elem osConfig.dotfiles.desktop [
    "hyprland"
    "sway"
    "swayfx"
  ];

  mkQtctConf =
    style: qtVersion:
    pkgs.writeText "qt${toString qtVersion}ct-${style}.conf" (
      ''
        [Appearance]
        icon_theme=${if style == "dark" then "Yaru-dark" else "Yaru"}
        style=${if style == "dark" then "Adwaita-Dark" else "Adwaita"}
        standard_dialogs=xdgdesktopportal
      ''
      + lib.optionalString (qtVersion == 5) ''
        [Fonts]
        general="${sansSerif},10,-1,5,50,0,0,0,0,0,Regular"
        fixed="${monospace},10,-1,5,50,0,0,0,0,0,Regular"
      ''
      + lib.optionalString (qtVersion == 6) ''
        [Fonts]
        general="${sansSerif},10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
        fixed="${monospace},10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
      ''
    );
in
{
  config = lib.mkIf isWindowManager {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.package = [
        pkgs.adwaita-qt
        pkgs.adwaita-qt6
        pkgs.yaru-theme
      ];
    };

    services.darkman = {
      darkModeScripts.qt-theme = ''
        mkdir -p ~/.config/qt{5,6}ct
        ln -sf ${mkQtctConf "dark" 5} ~/.config/qt5ct/qt5ct.conf
        ln -sf ${mkQtctConf "dark" 6} ~/.config/qt6ct/qt6ct.conf
      '';
      lightModeScripts.qt-theme = ''
        mkdir -p ~/.config/qt{5,6}ct
        ln -sf ${mkQtctConf "light" 5} ~/.config/qt5ct/qt5ct.conf
        ln -sf ${mkQtctConf "light" 6} ~/.config/qt6ct/qt6ct.conf
      '';
    };
  };
}
