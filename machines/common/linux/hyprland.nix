{ config, lib, ... }:

{
  config = lib.mkIf (config.dotfiles.desktop == "hyprland") {
    programs.hyprland.enable = true;
    services.hypridle.enable = true;
  };
}
