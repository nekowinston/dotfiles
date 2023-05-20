{pkgs, ...}: let
  mainUser = "winston";
in {
  imports = [
    ./hardware.nix
    ../common/linux
  ];

  networking = {
    hostName = "futomaki";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    blueman.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  users.users."${mainUser}" = {
    extraGroups = ["docker" "libvirtd" "wheel"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILm0O46zW/XfVOSwz0okRWYeOAg+wCVkCtCAoVTpZsOh"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "22.11";

  environment.systemPackages = with pkgs; [
    (discord.override {withOpenASAR = true;})
    gnome.gnome-boxes
    heroic
    lutris
    nur.repos.nekowinston.discover-overlay
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
  };
}
