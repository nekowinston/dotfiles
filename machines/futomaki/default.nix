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
    flatpak.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
    transmission.enable = true;
    transmission.openFirewall = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  users.users."${config.dotfiles.username}".extraGroups = ["docker" "libvirtd" "transmission"];

  environment.systemPackages = with pkgs; [
    cabextract
    gnome.gnome-boxes
    lutris-free
    nur.repos.nekowinston.discover-overlay
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
  };
}
