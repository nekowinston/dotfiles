{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.gaming;
  notify-send = lib.getExe' pkgs.libnotify "notify-send";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
in
{
  options.dotfiles.gaming.enable = lib.mkEnableOption "gaming configuration";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (heroic.override {
        extraPkgs = p: [
          p.gamemode
          p.mangohud
        ];
      })
      mangohud
      mangojuice
      umu-launcher
    ];

    # extra group to allow gamemode to park CPU cores
    users.users.${config.dotfiles.username}.extraGroups = [ "gamemode" ];

    programs = {
      gamemode = {
        enable = true;
        settings = {
          general.renice = 20;
          cpu.park_cores = true;
          custom.start =
            (pkgs.writeShellScript "gamemode-start" ''
              ${systemctl} stop --user wlsunset
              ${notify-send} 'GameMode started'
            '').outPath;
          custom.end =
            (pkgs.writeShellScript "gamemode-end" ''
              ${systemctl} start --user wlsunset
              ${notify-send} 'GameMode ended'
            '').outPath;
        };
      };
      steam = {
        enable = true;
        extraPackages = with pkgs; [
          gamemode
          liberation_ttf
          mangohud
          wineWowPackages.staging
          winetricks
        ];
      };
    };
  };
}
