{ config, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  dotfiles.desktop = "sway";

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  location = {
    latitude = 48.210033;
    longitude = 16.363449;
  };
  time.timeZone = "Europe/Vienna";

  services = {
    flatpak.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
    transmission.enable = true;
    transmission.openFirewall = true;
  };

  virtualisation.podman.enable = true;
  virtualisation.libvirtd.enable = true;

  users.users."${config.dotfiles.username}".extraGroups = [
    "libvirtd"
    "transmission"
  ];

  environment.systemPackages = with pkgs; [
    cabextract
    discover-overlay
    lutris-free
    mangohud
    virt-manager
    wineWowPackages.staging
    winetricks
  ];

  programs = {
    gamemode = {
      enable = true;
      settings = {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv.MANGOHUD = 1;
        extraPkgs =
          p: with p; [
            corefonts
            protontricks
            gamescope
          ];
      };
    };
  };

  system.stateVersion = "22.11";
}
