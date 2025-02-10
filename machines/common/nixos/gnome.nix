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
      desktopManager.gnome = {
        enable = true;
        sessionPath = [ pkgs.gnomeExtensions.appindicator ];
      };
    };

    # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/x11/desktop-managers/gnome.nix#L418
    environment.gnome.excludePackages = [
      pkgs.epiphany
      pkgs.gnome-text-editor
      pkgs.gnome-calculator
      pkgs.gnome-characters
      pkgs.gnome-clocks
      pkgs.gnome-console
      pkgs.gnome-contacts
      pkgs.gnome-font-viewer
      pkgs.gnome-logs
      pkgs.gnome-maps
      pkgs.gnome-music
      pkgs.gnome-system-monitor
      pkgs.gnome-weather
      pkgs.loupe
      pkgs.gnome-connections
      pkgs.simple-scan
      pkgs.totem
      pkgs.yelp
      pkgs.gnome-software
    ];
  };
}
