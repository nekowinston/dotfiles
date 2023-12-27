{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  imports = [./apps ./secrets/sops.nix ./xdg.nix];

  home = {
    packages = with pkgs; ([
        _1password
        age
        age-plugin-yubikey
        comma
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
        sops
        wakatime
        watchexec
      ]
      ++ lib.optionals (config.isGraphical && isLinux) [
        _1password-gui
        nur.repos.nekowinston.uhk-agent
      ]);
    sessionVariables = lib.mkIf isDarwin {
      SSH_AUTH_SOCK = "${config.programs.gpg.homedir}/S.gpg-agent.ssh";
    };
    stateVersion = "23.05";
  };

  home.mac-wallpaper = ./wallpapers/dhm_1610.png;

  programs = {
    home-manager.enable = true;
    man.enable = true;
    taskwarrior.enable = true;
  };

  sops.secrets."wakatime-cfg".path = "${config.xdg.configHome}/wakatime/.wakatime.cfg";
}
