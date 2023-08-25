{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware.nix];

  networking = {
    hostName = "futomaki";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    openssh.enable = true;
    pcscd.enable = true;
    transmission.enable = true;
    transmission.openFirewall = true;
  };

  virtualisation.podman.enable = true;
  virtualisation.libvirtd.enable = true;

  users.users."${config.dotfiles.username}".extraGroups = ["libvirtd" "transmission"];

  environment.systemPackages = with pkgs; [
    cabextract
    heroic
    mangohud
    nur.repos.nekowinston.discover-overlay
    virt-manager
    wineWowPackages.waylandFull
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
        extraPkgs = p: with p; [corefonts protontricks];
      };
    };
  };
}
