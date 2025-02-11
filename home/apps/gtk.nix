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
  inherit (config.fonts.fontconfig) defaultFonts;
  sharedGtkSettings = {
    gtk-decoration-layout = if isWindowManager then ":menu" else "close,maximize,minimize:menu";
    gtk-enable-event-sounds = true;
    gtk-enable-input-feedback-sounds = true;
    gtk-sound-theme-name = theme.light;
  };
  sharedGtkCss = # css
    ''
      window, decoration, decoration-overlay {
        border-radius: 0;
        box-shadow: unset;
      }
      window-frame, .window-frame:backdrop {
        box-shadow: 0 0 0 black;
        border-style: none;
        margin: 0;
        border-radius: 0;
      }
      .titlebar {
        border-radius: 0;
      }
      .window-frame.csd.popup {
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(0, 0, 0, 0.13);
      }
      .header-bar {
        background-image: none;
        background-color: #ededed;
        box-shadow: none;
      }
      GtkLabel.title {
        opacity: 0;
      }
    '';

  mkDconfSwitchScript' =
    input:
    lib.concatLines (
      lib.flatten (
        lib.mapAttrsToList (
          basepath: opts:
          lib.mapAttrsToList (
            key: value: "${lib.getExe pkgs.dconf} write /${basepath}/${key} \"'${value}'\""
          ) opts
        ) input
      )
    );
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
        name = theme.light;
        package = pkgs.yaru-theme;
      };
      theme = {
        name = theme.light;
        package = pkgs.yaru-theme;
      };
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3 = {
        extraConfig = sharedGtkSettings;
        extraCss = lib.mkIf isWindowManager sharedGtkCss;
      };
      gtk4 = {
        extraConfig = sharedGtkSettings;
        extraCss = lib.mkIf isWindowManager sharedGtkCss;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/sound" = {
        event-sounds = true;
        input-feedback-sounds = true;
        theme-name = theme.light;
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = if isWindowManager then ":appmenu" else "close,maximize,minimize:appmenu";
      };
    };

    # don't want stuff that doesn't use XDG specs
    home.file = {
      ".icons/default/index.theme".enable = false;
      ".icons/${config.gtk.iconTheme.name}".enable = false;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

    services.darkman = lib.mkIf isWindowManager {
      lightModeScripts.gtk-theme = mkDconfSwitchScript' {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-light";
          gtk-theme = theme.light;
          icon-theme = theme.light;
        };
      };
      darkModeScripts.gtk-theme = mkDconfSwitchScript' {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = theme.dark;
          icon-theme = theme.dark;
        };
      };
    };
  };
}
