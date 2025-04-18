{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./intel-arc.nix
    ./secure-boot.nix
  ];

  dotfiles = {
    desktop = "swayfx";
    gaming.enable = true;
    vscode.enable = true;
  };

  hardware.keyboard.uhk.enable = true;
  environment.systemPackages = [ pkgs.uhk-agent ];

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

  programs.obs-studio = {
    enable = true;
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
  };
  boot = lib.mkIf config.programs.obs-studio.enable {
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

    # extra config for the v4l2loopback module,
    # allowing for an extra loopback device created via gstreamer
    extraModprobeConfig = ''
      options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Virtual Camera,iPhone Magic Webcam" exclusive_caps=1,1
    '';
  };

  system.stateVersion = "24.11";
}
