{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.gaming;
  gamePkgs = with pkgs; [
    corefonts
    gamescope
    mangohud
    wineWowPackages.staging
    winetricks
  ];
in
{
  options.dotfiles.gaming.enable = lib.mkEnableOption "gaming configuration";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discover-overlay
      (lutris.override { extraPkgs = (pkgs: gamePkgs); })
    ];

    # enable 32bit support for Steam
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
    services.pulseaudio.support32Bit = true;

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
        extraPackages = gamePkgs;
      };
    };
  };
}
