{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  gtk = lib.mkIf isLinux {
    enable = true;
    iconTheme.name = "Papirus-Dark";
    theme.name = "Catppuccin-Mocha-Compact-Pink-Dark";
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

  home.pointerCursor = lib.mkIf isLinux {
    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
    gtk.enable = true;
    size = 24;
    x11.enable = true;
  };

  programs.i3status-rust = lib.mkIf isLinux {
    enable = true;
    bars.top = {
      blocks = [
        {
          block = "vpn";
          driver = "mullvad";
          format_connected = "󰍁 ";
          format_disconnected = "󰍀 ";
          state_connected = "good";
          state_disconnected = "critical";
        }
        {
          block = "tea_timer";
          done_cmd = "notify-send 'Timer Finished'";
        }
        {
          block = "time";
          interval = 60;
          format = " $timestamp.datetime(f:'%d/%m %R') ";
        }
        {
          block = "notify";
          format = " $icon {($notification_count.eng(w:1)) |}";
          driver = "swaync";
          click = [
            {
              button = "left";
              action = "show";
            }
            {
              button = "right";
              action = "toggle_paused";
            }
          ];
        }
      ];
      settings = {
        icons.icons = "material-nf";
        theme.overrides = {
          idle_fg = "#cdd6f4";
          idle_bg = "#00000000";
          info_fg = "#89b4fa";
          info_bg = "#00000000";
          good_fg = "#a6e3a1";
          good_bg = "#00000000";
          warning_fg = "#fab387";
          warning_bg = "#00000000";
          critical_fg = "#f38ba8";
          critical_bg = "#00000000";
          separator = " ";
          separator_bg = "auto";
          separator_fg = "auto";
        };
      };
    };
  };

  programs.rofi = lib.mkIf isLinux {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "IBM Plex Sans 14";
    extraConfig.icon-theme = "Papirus-Dark";
    terminal = "wezterm";
    theme = ./rofi/theme.rasi;
  };

  programs.swaylock = lib.mkIf isLinux {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      ignore-empty-password = true;
      font = "IBM Plex Sans";
      fade-in = "0.2";
      screenshots = true;

      clock = true;
      timestr = "%H:%M";
      datestr = "%A, %d %B";

      indicator = true;
      indicator-radius = "100";
      indicator-thickness = "10";

      effect-blur = "30x2";
      effect-vignette = "0.5:0.5";

      text-color = "cdd6f4";
      text-clear-color = "11111b";
      text-ver-color = "11111b";
      text-wrong-color = "11111b";

      ring-color = "1e1e2e";
      key-hl-color = "f5c2e7";
      line-color = "f5c2e7";
      inside-color = "00000088";
      separator-color = "00000000";

      inside-clear-color = "f2cdcd88";
      line-clear-color = "f2cdcd";
      ring-clear-color = "f2cdcd";

      inside-ver-color = "89dceb88";
      line-ver-color = "89dceb";
      ring-ver-color = "89dceb";

      inside-wrong-color = "f38ba888";
      line-wrong-color = "f38ba8";
      ring-wrong-color = "f38ba8";
    };
  };
}
