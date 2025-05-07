{ pkgs, ... }:
{
  imports = [
    ./games.nix
    ./hardware.nix
    ./intel-arc.nix
    ./obs.nix
    ./secure-boot.nix
  ];

  dotfiles = {
    desktop = "sway";
    vscode.enable = true;
  };

  hardware.keyboard.uhk.enable = true;
  environment.systemPackages = [
    pkgs.libreoffice-fresh
    pkgs.uhk-agent
  ];

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
    openssh.enable = true;
    pcscd.enable = true;
  };

  virtualisation.podman.enable = true;

  system.stateVersion = "24.11";
}
