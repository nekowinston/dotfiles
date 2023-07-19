{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  imports = [./apps ./langs ./secrets/sops.nix ./xdg.nix];

  home = {
    packages = with pkgs; ([
        _1password
        age
        age-plugin-yubikey
        fd
        ffmpeg
        file
        gh
        git-crypt
        gocryptfs
        imagemagick
        just
        mdcat
        mosh
        nix-output-monitor
        nur.repos.nekowinston.icat
        nekowinston-nur.sizzy
        nvd
        ranger
        ripgrep
        sops
        wakatime
      ]
      ++ lib.optionals isLinux [
        (discord.override {
          withOpenASAR = true;
          withTTS = true;
        })
        _1password-gui
        jetbrains.goland
        jetbrains.webstorm
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
