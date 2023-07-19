{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  home.packages = lib.mkIf isLinux [pkgs.playerctl];

  programs.waybar = lib.mkIf isLinux {
    enable = true;
    settings = [
      {
        bar_id = "bar-0";
        ipc = true;
        layer = "top";
        position = "top";
        margin-left = 7;
        margin-right = 7;
        margin-top = 7;
        height = 32;
        modules-left = ["sway/workspaces" "sway/mode"];
        modules-center = ["mpris"];
        modules-right = ["tray" "pulseaudio" "clock" "custom/notification"];
        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };
        "sway/mode" = {
          format = "{}";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = " <span foreground='red'><sup> </sup></span>";
            none = " ";
            dnd-notification = " <span foreground='red'><sup> </sup></span>";
            dnd-none = " ";
            inhibited-notification = " <span foreground='red'><sup> </sup></span>";
            inhibited-none = " ";
            dnd-inhibited-notification = " <span foreground='red'><sup> </sup></span>";
            dnd-inhibited-none = " ";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% 󰂯 ";
          format-muted = "󰝟 ";
          format-icons = {
            headphone = "󰋋 ";
            hands-free = "󰋎 ";
            headset = "󰋎 ";
            phone = " ";
            portable = " ";
            car = " ";
            default = ["󰕿 " "󰖀 " "󰕾 "];
          };
          on-click = "pavucontrol";
        };
        mpris = {
          format = "{dynamic}";
          format-paused = "";
          interval = 10;
        };
        tray = {
          reverse-direction = true;
          spacing = 5;
        };
        spacing = 4;
      }
    ];
    style = ''
      @define-color red #f38ba8;
      @define-color mauve #cba6f7;
      @define-color pink #f5c2e7;
      @define-color crust #11111c;
      @define-color base #1e1e2e;
      @define-color text #cdd6f4;

      * {
        font-family: IBM Plex Sans;
        font-size: 16px;
      }

      window#waybar {
        background-color: @base;
        border: 2px solid @crust;
        border-radius: 5px;
        color: @text;
      }

      #workspaces button {
        padding: 0 5px;
        color: alpha(@mauve, 0.5);
      }

      #workspaces button.focused {
        color: @pink;
      }

      #workspaces button.urgent {
        color: @crust;
        background-color: @red;
      }

      #clock,
      #mpris,
      #pulseaudio,
      #tray {
        padding: 0 5px;
      }
    '';
  };

  wayland.windowManager.sway.config.bars = [
    {
      position = "top";
      command = "${config.programs.waybar.package}/bin/waybar";
      mode = "hide";
    }
  ];

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
      ignore-empty-password = false;
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
