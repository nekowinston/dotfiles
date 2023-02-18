{
  config,
  lib,
  pkgs,
  machine,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  imports =
    [
      ./apps/firefox.nix
      ./apps/git.nix
      ./apps/gpg.nix
      ./apps/i3.nix
      ./apps/kubernetes.nix
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
    ]
    ++ lib.optionals (builtins.pathExists ./secrets/default.nix) [./secrets];

  home = {
    packages = with pkgs; ([
        zsh
        fd
        ffmpeg
        file
        imagemagick
        mdcat
        ranger
        ripgrep
        git-secret
        cargo
        unstable.deno
        rustc
        gh

        nur.repos.nekowinston.org-stats
        (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
        wezterm
      ]
      ++ lib.optionals isDarwin [
        iina
      ]
      ++ lib.optionals isLinux [
        _1password-gui
        insomnia
        mattermost-desktop
      ]
      ++ lib.optionals (isLinux && machine.personal) [
        nur.repos.nekowinston.discover-overlay
        (unstable.discord.override {withOpenASAR = true;})
        lutris
      ]);

    sessionVariables =
      {
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        CUDA_CACHE_PATH = "${config.xdg.dataHome}/nv";
        DOCKER_CONFIG = "${config.xdg.configHome}/docker";
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
        PATH = "$PATH:${config.xdg.dataHome}/krew/bin:$GOPATH/bin";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        # XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
        XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
      }
      // (
        if isDarwin
        then {
          SSH_AUTH_SOCK = "${config.xdg.configHome}/gnupg/S.gpg-agent.ssh";
        }
        else {}
      );

    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
    go = {
      enable = true;
      goPath = "${config.xdg.dataHome}/go";
    };
    man.enable = true;
    taskwarrior.enable = true;
  };

  xdg = {
    enable = true;
    userDirs.enable = isLinux;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
  };
}
