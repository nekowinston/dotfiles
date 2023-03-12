{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  home.packages = lib.mkIf isLinux (with pkgs; [
    cliphist
    grim
    slurp
    wl-clipboard
    nur.repos.nekowinston.swww
  ]);

  programs.waybar = lib.mkIf isLinux {
    enable = true;
    package = pkgs.unstable.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        margin-left = 5;
        margin-right = 5;
        margin-top = 5;
        modules-left = ["sway/workspaces" "mpd"];
        modules-center = [];
        modules-right = ["tray" "cpu" "memory" "clock"];
        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };
        mpd = {
          format = "{artist} - {title}";
          format-disconnected = "";
          format-paused = "";
          format-stopped = "";
          interval = 10;
        };
        tray = {
          reverse-direction = true;
          spacing = 5;
        };
        cpu = {
          format = " {usage:2}%";
          interval = 1;
        };
        memory = {
          format = " {percentage:2}%";
          interval = 1;
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
        background-color: @red;
      }

      #clock,
      #cpu,
      #idle_inhibitor,
      #memory,
      #mpd,
      #pulseaudio,
      #tray {
        padding: 0 5px;
      }

      #mpd {
        font-family: Symbols Nerd Font, Victor Mono;
        font-style: italic;
      }

      #cpu,
      #memory {
        font-family: Berkeley Mono;
      }
    '';
  };
}
