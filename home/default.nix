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
        ranger
        ripgrep
        sops
      ]
      ++ lib.optionals isLinux [
        _1password-gui
        kooha
        jetbrains.goland
        jetbrains.webstorm
      ]);
    sessionVariables = lib.mkIf isDarwin {
      SSH_AUTH_SOCK = "${config.programs.gpg.homedir}/S.gpg-agent.ssh";
    };
    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
    man.enable = true;
    taskwarrior.enable = true;
  };

  home.mac-wallpaper = ./wallpapers/dhm_1610.png;
}
