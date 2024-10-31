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
in
{
  config = lib.mkIf config.wayland.windowManager.sway.enable {
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
