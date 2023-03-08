{
  config,
  pkgs,
  ...
}: let
  mainUser = "winston";
in {
  imports = [
    ./hardware.nix
    ../common/linux
    ../common/hyprland.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;
    # for nvidia
    loader.systemd-boot.consoleMode = "0";
    kernelParams = ["quiet" "splash" "vt.global_cursor_default=0"];
  };

  hardware = {
    bluetooth.enable = true;
  };

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

  users.users."${mainUser}" = {
    extraGroups = ["wheel" "docker"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILm0O46zW/XfVOSwz0okRWYeOAg+wCVkCtCAoVTpZsOh"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "22.11";
}
