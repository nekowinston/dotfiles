{
  config,
  lib,
  pkgs,
  ...
}: let
  commonSettings = {
    layer = "top";
    position = "top";

    height = 32;
    spacing = 2;
    margin = "2";

    modules-center = ["hyprland/window"];
    modules-right = ["tray" "idle_inhibitor" "pulseaudio" "clock"];

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "󰒲";
      };
    };

    tray.spacing = 10;

    pulseaudio = {
      format = "{icon} {volume}%";
      format-icons.default = ["" "" ""];
      on-click = "pavucontrol";
    };
  };
in {
  config = lib.mkIf (config.isGraphical && pkgs.stdenv.isLinux) {
    programs.waybar = {
      enable = true;

      settings = {
        hyprland =
          commonSettings
          // {
            modules-left = ["hyprland/workspaces"];
            "hyprland/workspaces" = {
              format = "{icon}";
              on-click = "activate";
              format-icons = {
                "1" = "Ⅰ";
                "2" = "Ⅱ";
                "3" = "Ⅲ";
                "4" = "Ⅳ";
                "5" = "Ⅴ";
                "6" = "Ⅵ";
                "7" = "Ⅶ";
                "8" = "Ⅷ";
                "9" = "Ⅸ";
                "10" = "Ⅹ";
              };
              persistent-workspaces."*" = 10;
            };
          };
      };

      style = ''
        @define-color red #f38ba8;
        @define-color pink #f5c2e7;
        @define-color crust #11111c;
        @define-color base #1e1e2e;
        @define-color text #cdd6f4;
        @define-color surface0 #313244;
        @define-color surface2 #585b70;

        * {
          font-family: Symbols Nerd Font, IBM Plex Sans;
          font-size: 16px;
          color: @text;
        }

        window#waybar {
          background-color: @base;
          border: 2px solid @crust;
          border-radius: 5px;
        }

        #workspaces button:first-child {
          padding: 0 5px;
          border-radius: 5px 0 0 5px;
          border-left: 2px solid @crust;
        }
        #workspaces button.active:first-child {
          padding: 0 5px;
          box-shadow: unset;
          border-radius: 5px 0 0 5px;
          border-left: 2px solid @pink;
          border-top: 2px solid @pink;
          border-bottom: 2px solid @pink;
        }

        #workspaces button {
          padding: 0 5px;
          border-radius: 0;
          border-top: 2px solid @crust;
          border-bottom: 2px solid @crust;
        }

        #workspaces button:hover {
          background: @surface2;
        }

        #workspaces button.active {
          color: @pink;
          background: @surface0;
          border-top: 2px solid @pink;
          border-bottom: 2px solid @pink;
        }

        #workspaces button.urgent {
          background-color: @red;
        }

        #clock, #network, #pulseaudio, #tray, #idle_inhibitor {
          padding: 0 10px;
        }
      '';
    };
  };
}
