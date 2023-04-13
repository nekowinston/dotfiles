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
    bat.enable = true;
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
      };
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    fzf.enable = true;

    lsd = {
      enable = true;
      enableAliases = true;
    };

    mcfly.enable = true;
    nix-index.enable = true;

    starship = {
      enable = true;
      package = pkgs.unstable.starship;
    };

    tealdeer = {
      enable = true;
      settings = {
        style = {
          description.foreground = "white";
          command_name.foreground = "green";
          example_text.foreground = "blue";
          example_code.foreground = "white";
          example_variable.foreground = "yellow";
        };
        updates.auto_update = true;
      };
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

        # WezTerm
        [[ "$TERM_PROGRAM" == "WezTerm" ]] && TERM=wezterm

        source <(konf-go shellwrapper zsh)
        source <(konf-go completion zsh)
        # open last konf on new shell session
        export KUBECONFIG=$(konf-go --silent set -)
      '';

      envExtra = ''
        export PATH="$PATH:${config.xdg.dataHome}/krew/bin:${config.home.sessionVariables.GOPATH}/bin:${config.home.sessionVariables.CARGO_HOME}/bin:$HOME/.local/bin"
        export ZVM_INIT_MODE=sourcing
      '';

      dotDir = ".config/zsh";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "colored-man-pages"
          "colorize"
          "docker"
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
          src = pkgs.zsh-nix-shell;
          file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
        }
      ];
      shellAliases = {
        cat =
          if isDarwin
          then "bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo Catppuccin-mocha || echo Catppuccin-latte)"
          else "bat";
        # switch between yubikeys for the same GPG key
        switch_yubikeys = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";
      };
      history = {
        path = "${config.xdg.configHome}/zsh/history";
      };
    };
  };

  xdg.configFile = {
    "lsd" = symlink "home/apps/lsd" {recursive = true;};
    "starship.toml" = symlink "home/apps/starship/config.toml" {};
    "zsh/functions" = symlink "home/apps/zsh/functions" {recursive = true;};
  };
}
