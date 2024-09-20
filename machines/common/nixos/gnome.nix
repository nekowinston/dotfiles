{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.desktop == "gnome") {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];

    hardware.pulseaudio.enable = false;

    # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/x11/desktop-managers/gnome.nix#L467
    environment.gnome.excludePackages = with pkgs.gnome; [
      # baobab
      epiphany
      # gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-weather
      # nautilus
      pkgs.gnome-connections
      # pkgs.gnome-console
      pkgs.gnome-text-editor
      pkgs.loupe
      # pkgs.snapshot
      simple-scan
      totem
      yelp
    ];
  };
}
