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
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_2;
    kernelParams = ["quiet" "splash"];
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

  programs = {
    steam = {
      enable = true;
      package = pkgs.unstable.steam.override {
        extraPkgs = pkgs: with pkgs; [gamemode mangohud];
        extraLibraries = pkgs:
          with config.hardware.opengl;
            if pkgs.hostPlatform.is64bit
            then [package] ++ extraPackages
            else [package32] ++ extraPackages32;
      };
    };
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
