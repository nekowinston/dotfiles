{ pkgs, ... }:
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

  home = {
    packages = with pkgs; [
      kooha
      overskride
      pwvucontrol
      sway-contrib.grimshot
      swayosd
      wl-clipboard
    ];
  };
}
