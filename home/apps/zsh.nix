{
  config,
  flakePath,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  symlink = fileName: {recursive ? false}: {
    source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/${fileName}";
    recursive = recursive;
  };
in {
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

    fzf = {
      enable = true;
      defaultOptions = [
        "--height=30%"
        "--layout=reverse"
        "--info=inline"
        "--color=spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
      ];
    };

    lsd = {
      enable = true;
      enableAliases = true;
    };

    mcfly.enable = true;
    nix-index.enable = true;

    starship = {
      enable = true;
      package = pkgs.starship;
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
      enableSyntaxHighlighting = false;

      initExtra = let
        functionsDir = "${config.home.homeDirectory}/${config.programs.zsh.dotDir}/functions";
      in ''
        for conf in "${functionsDir}"/**/*.zsh; do
          source "$conf"
        done
      '';

      sessionVariables = {
        ZVM_INIT_MODE = "sourcing";
        ZVM_CURSOR_BLINKING_BEAM = "1";
        LESSHISTFILE = "-";
      };

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
          name = "zsh-fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
        {
          name = "zsh-nix-shell";
          src = pkgs.zsh-nix-shell;
          file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
        }
        {
          name = "zsh-vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
      shellAliases = {
        cat =
          if isDarwin
          then "bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo Catppuccin-mocha || echo Catppuccin-latte)"
          else "bat";
        # switch between yubikeys for the same GPG key
        switch_yubikeys = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";
        tree = "lsd --tree";
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
