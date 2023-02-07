{ config, lib, pkgs, ... }:

let
  userName = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";

  inherit (pkgs.stdenv.hostPlatform) isLinux;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  unstable = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  pkgsUnstable = import unstable { config.allowUnfree = true; };

  personalMachine = true;
in

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    "${builtins.fetchTarball "https://github.com/Mic92/sops-nix/archive/feat/home-manager.tar.gz"}/modules/home-manager/sops.nix"
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
    ./modules/sops.nix
    ./modules/vscode.nix
    ./modules/wezterm.nix
    ./modules/zsh.nix
  ] ++ lib.optionals (builtins.pathExists ./modules/secrets.nix) [
    # hotfix: use fucking git-secret, this is atrocious beyond belief
    ./modules/secrets.nix
  ];

  catppuccin = {
    defaultTheme = "mocha";
    bat.enable = true;
    btop.enable = true;
    dircolors.enable = true;
    k9s.enable = true;
  };

  manual.manpages.enable = false;

  home = {
    username = userName;
    homeDirectory = homeDir;

    packages = with pkgs; ([
      zsh
      fd ffmpeg file imagemagick mdcat ranger ripgrep

      podman podman-compose qemu
      git-secret

      cargo deno rustc

      (callPackage ./packages/org-stats {})
      (callPackage ./packages/python3.catppuccin-catwalk {})
      (nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"]; })

      pkgsUnstable.jetbrains.clion
      pkgsUnstable.jetbrains.goland
      pkgsUnstable.jetbrains.phpstorm
      pkgsUnstable.jetbrains.pycharm-professional
      pkgsUnstable.jetbrains.webstorm
      pkgsUnstable.wezterm
    ] ++ lib.optionals isDarwin [
      iina
    ] ++ lib.optionals isLinux [
      _1password-gui
      insomnia
      mattermost-desktop
    ] ++ lib.optionals (isLinux && personalMachine) [
      (callPackage ./packages/python3.discover-overlay {})
      pkgsUnstable.discord
      lutris
    ]);

    sessionVariables = {
      TERMINAL = "wezterm";
      LESSHISTFILE = "-";

      CARGO_HOME="${config.xdg.dataHome}/cargo";
      NPM_CONFIG_USERCONFIG="${config.xdg.configHome}/npm/npmrc";
      RUSTUP_HOME="${config.xdg.dataHome}/rustup";
      PATH="$PATH:${config.xdg.dataHome}/krew/bin:$GOPATH/bin";
    } // (if isDarwin then {
      # https://github.com/NixOS/nix/issues/2033
      NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels\${NIX_PATH:+:$NIX_PATH}";
      SSH_AUTH_SOCK = "${config.xdg.configHome}/gnupg/S.gpg-agent.ssh";
    } else {});

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
    cacheHome = "${homeDir}/.cache";
    configHome = "${homeDir}/.config";
    dataHome = "${homeDir}/.local/share";
  };
}
