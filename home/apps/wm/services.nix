{
  config,
  lib,
  osConfig,
  ...
}:
let
  isWindowManager = builtins.elem osConfig.dotfiles.desktop [
    "hyprland"
    "sway"
    "swayfx"
  ];
in
{
  config = lib.mkIf isWindowManager {
    services = {
      clipman.enable = true;
      gnome-keyring = {
        enable = true;
        components = [ "secrets" ];
      };
      wlsunset = {
        enable = true;
        latitude = toString config.location.latitude;
        longitude = toString config.location.longitude;
      };
      udiskie.enable = true;
    };
  };
}
