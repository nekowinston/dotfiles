{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  symlink = fileName: {recursive ? false}: {
    source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/${fileName}";
    recursive = recursive;
  };
in {
  home.sessionVariables = {LESSHISTFILE = "-";};

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    fzf.enable = true;

    lsd = {
      enable = true;
      enableAliases = true;
    };

    mcfly.enable = true;

    starship = {
      enable = true;
      package = pkgs.unstable.starship;
    };

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    zoxide.enable = true;

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;

      initExtra = let
        functionsDir = "${config.home.homeDirectory}/${config.programs.zsh.dotDir}/functions";
      in ''
        for conf in "${functionsDir}"/**/*.zsh; do
          source "$conf"
        done
      '';

      envExtra = ''
        export PATH="$PATH:${config.xdg.dataHome}/krew/bin"
        export ZVM_INIT_MODE=sourcing
      '';

      dotDir = ".config/zsh";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "colored-man-pages"
          "colorize"
          "docker-compose"
          "git"
          "kubectl"
        ];
      };
      plugins = [
        {
          name = "zsh-vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];
      shellAliases = {
        # switch between yubikeys for the same GPG key
        cat =
          if isDarwin
          then "bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)"
          else "bat";
        switch_yubikeys = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";
      };
      history = {
        path = "${config.xdg.configHome}/zsh/history";
      };
    };
  };

  xdg.configFile = {
    "lsd" = symlink "modules/lsd" {recursive = true;};
    "starship.toml" = symlink "modules/starship/config.toml" {};
    "zsh/functions" = symlink "modules/zsh/functions" {recursive = true;};
  };
}
