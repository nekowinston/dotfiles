{
  lib,
  osConfig,
  pkgs,
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
  imports = [
    ./hyprland.nix
    # ./i3-status-rust.nix
    ./rofi.nix
    ./services.nix
    ./sway.nix
    ./swaylock.nix
    ./swaync.nix
    ./swayosd.nix
    ./swaywsr.nix
    ./waybar.nix
  ];

  config = lib.mkIf isWindowManager {
    home = {
      packages = with pkgs; [
        sway-contrib.grimshot
        swayosd
        wl-clipboard
      ];
    };
  };
}
