{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  isWindowManager =
    config.wayland.windowManager.hyprland.enable || config.wayland.windowManager.sway.enable;

  isSwayFx = osConfig.dotfiles.desktop == "swayfx";

  boolString = cond: if cond then "true" else "false";
  buildStyle =
    appearance:
    pkgs.runCommandNoCC "hm_swayncstyle${appearance}.css" {
      nativeBuildInputs = [ pkgs.dart-sass ];
      style = # scss
        ''
          @use "${./scss}/swayosd";

          @include swayosd.main(
            $fancy: ${boolString isSwayFx},
            $dark: ${boolString (appearance == "dark")}
          );
        '';
      passAsFile = [ "style" ];
    } "sass --no-source-map $stylePath $out";
in
{
  config = lib.mkIf isWindowManager {
    services.swayosd = {
      enable = true;
      stylePath = buildStyle "dark";
    };
  };
}
