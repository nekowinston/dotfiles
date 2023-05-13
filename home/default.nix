{
  config,
  flakePath,
  lib,
  pkgs,
  machine,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  secretsAvailable = builtins.pathExists ./secrets/default.nix;
in {
  imports =
    [
      ./apps/browsers.nix
      ./apps/fonts.nix
      ./apps/git.nix
      ./apps/gpg.nix
      ./apps/i3.nix
      ./apps/kubernetes.nix
      ./apps/macos.nix
      ./apps/mail.nix
      ./apps/music.nix
      ./apps/neovim.nix
      ./apps/newsboat.nix
      ./apps/rice.nix
      ./apps/vscode.nix
      ./apps/wayland.nix
      ./apps/wezterm.nix
      ./apps/zsh.nix
      ./secrets/sops.nix
      ./xdg.nix
    ]
    ++ (
      if secretsAvailable
      then [./secrets]
      else [./secrets/fallback.nix]
    );

  home = {
    packages = with pkgs; ([
        fd
        ffmpeg
        file
        imagemagick
        mdcat
        ranger
        ripgrep
        git-secret
        gh
        mosh

        wezterm
        podman
        podman-compose
        qemu
      ]
      ++ lib.optionals isLinux [
        _1password-gui
        #insomnia
        #mattermost-desktop
        neovide
        kooha
        #jetbrains.webstorm
        gnome.gnome-boxes
      ]);
    sessionVariables = lib.mkIf isDarwin {
      SSH_AUTH_SOCK = "${config.programs.gpg.homedir}/S.gpg-agent.ssh";
    };

    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
    man.enable = true;
    mpv.enable = isLinux;
    taskwarrior.enable = true;
    mangohud = {
      enable = isLinux && machine.personal;
      package = pkgs.mangohud;
    };
    zathura.enable = true;
  };

  xdg.configFile."ideavim/ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/ideavim/ideavimrc";
}
