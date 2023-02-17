{
  config,
  lib,
  pkgs,
  sops,
  machine,
  hyprland,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  imports =
    [
      hyprland
      sops
      ./catppuccin
      ./modules/firefox.nix
      ./modules/git.nix
      ./modules/gpg.nix
      ./modules/i3.nix
      ./modules/kubernetes.nix
      ./modules/mail.nix
      ./modules/music.nix
      ./modules/neovim.nix
      ./modules/newsboat.nix
      ./modules/rice.nix
      ./modules/sops.nix
      ./modules/vscode.nix
      ./modules/wayland.nix
      ./modules/wezterm.nix
      ./modules/zsh.nix
    ]
    ++ lib.optionals (builtins.pathExists ./modules/secrets.nix) [./modules/secrets.nix];

  catppuccin = {
    defaultTheme = "mocha";
    bat.enable = true;
    btop.enable = true;
    dircolors.enable = true;
    k9s.enable = true;
  };

  manual.manpages.enable = false;

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
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        PATH = "$PATH:${config.xdg.dataHome}/krew/bin:$GOPATH/bin";
      }
      // lib.mkIf isDarwin {
        # https://github.com/NixOS/nix/issues/2033
        NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels\${NIX_PATH:+:$NIX_PATH}";
        SSH_AUTH_SOCK = "${config.xdg.configHome}/gnupg/S.gpg-agent.ssh";
      };

    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
    go = {
      enable = true;
      goPath = ".local/share/go";
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
