{ config, lib, ... }:
let
  isWindowManager =
    config.wayland.windowManager.hyprland.enable || config.wayland.windowManager.sway.enable;
in
{
  config = lib.mkIf isWindowManager {
    services.swayosd = {
      enable = true;
    };
  };
}
