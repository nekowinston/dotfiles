{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  imports = [
    ./apps/browsers.nix
    ./apps/fonts.nix
    ./apps/git.nix
    ./apps/gpg.nix
    ./apps/i3.nix
    ./apps/kubernetes.nix
    ./apps/macos.nix
    ./apps/mail.nix
    ./apps/media.nix
    ./apps/neovim.nix
    ./apps/newsboat.nix
    ./apps/rice.nix
    ./apps/vscode.nix
    ./apps/wezterm.nix
    ./apps/zsh.nix
    ./secrets/sops.nix
    ./xdg.nix
  ];

  home = {
    packages = with pkgs; ([
        fd
        ffmpeg
        file
        imagemagick
        just
        mdcat
        ranger
        ripgrep
        git-secret
        gh
        mosh
        podman
        podman-compose
        qemu
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
    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
    man.enable = true;
    taskwarrior.enable = true;
  };

  xdg.configFile."ideavim/ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/ideavim/ideavimrc";
  xdg.configFile."Yubico/u2f_keys".text = ''
    winston:+SzANNyl5RpjNZFCthItSi7rQgiNqKNQztm2omNDnMOMNYXbnpoxMY/tqNCqoUtcAnkSmfC1/2E3WMZZ+IupFw==,gw1FnUrGJ2/vsxrcyOP17603yWSSk2OaatqvqkzhiEmRd/FAzWuXYE2YA16SBB9n+f6IypjerPgwY06zOw3DOA==,es256,+presence%
  '';
}
