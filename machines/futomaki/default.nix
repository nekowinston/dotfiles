{ config, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  dotfiles = {
    desktop = "sway";
    gaming.enable = true;
  };

  hardware.keyboard.uhk.enable = true;

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

  virtualisation = {
    libvirtd.enable = true;
    podman.enable = true;
  };

  users.users."${config.dotfiles.username}".extraGroups = [
    "libvirtd"
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
        obs-backgroundremoval
        obs-composite-blur
        obs-gstreamer
        obs-move-transition
        obs-pipewire-audio-capture
        obs-vaapi
        obs-vkcapture
        wlrobs
      ];
    })
    virt-manager
    virtiofsd
  ];

  system.stateVersion = "22.11";
}
