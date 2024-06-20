{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
{
  imports = [
    ./apps
    ./secrets
    ./xdg.nix
  ];

  home = {
    packages =
      with pkgs;
      (
        [
          _1password
          age
          age-plugin-yubikey
          deno
          fd
          ffmpeg
          file
          gh
          git-crypt
          gocryptfs
          imagemagick
          just
          mdcat
          nix-output-monitor
          nur.repos.nekowinston.icat
          nvd
          ranger
          ripgrep
          watchexec
        ]
        ++ lib.optionals (config.isGraphical && isLinux) [
          _1password-gui
          uhk-agent
          neovide
        ]
      );
    sessionVariables = lib.mkIf isDarwin {
      SSH_AUTH_SOCK = "${config.programs.gpg.homedir}/S.gpg-agent.ssh";
    };
    stateVersion = "23.05";
  };

  home.mac-wallpaper = ./wallpapers/dhm_1610.png;
  xdg.configFile.sketchybar.source = lib.mkIf isDarwin ./apps/sketchybar;

  programs = {
    home-manager.enable = true;
    man.enable = true;
    taskwarrior.enable = true;
  };

  age.secrets."wakatime.cfg".path = "${config.home.sessionVariables.WAKATIME_HOME}/.wakatime.cfg";
}
