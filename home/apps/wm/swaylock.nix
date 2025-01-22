{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (config.fonts.fontconfig) defaultFonts;
  fontSans = builtins.head defaultFonts.sansSerif;

  theme = lib.milspec.dark;
in
{
  config = lib.mkIf config.wayland.windowManager.sway.enable {
    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${lib.getExe config.programs.swaylock.package} -f";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "swaymsg 'output * dpms off'";
          resumeCommand = "swaymsg 'output * dpms on'";
        }
      ];
    };

    programs.swaylock = lib.mkIf isLinux {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        ignore-empty-password = false;
        font = fontSans;

        indicator = true;
        indicator-radius = "100";
        indicator-thickness = "10";

        screenshots = true;

        text-color = theme.fg;
        text-clear-color = theme.core;
        text-ver-color = theme.core;
        text-wrong-color = theme.core;

        ring-color = theme.bg;
        key-hl-color = theme.rose;
        line-color = theme.rose;
        inside-color = "00000088";
        separator-color = "00000000";

        inside-clear-color = theme.orange + "88";
        line-clear-color = theme.orange;
        ring-clear-color = theme.orange;

        inside-ver-color = theme.blue + "88";
        line-ver-color = theme.blue;
        ring-ver-color = theme.blue;

        inside-wrong-color = theme.red + "88";
        line-wrong-color = theme.red;
        ring-wrong-color = theme.red;

        clock = true;
        timestr = "%H:%M";
        datestr = "%A, %d %B";

        effect-blur = "30x2";
        effect-vignette = "0.5:0.5";

        fade-in = "0.2";
      };
    };
  };
}
