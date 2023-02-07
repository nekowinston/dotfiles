{ config, lib, pkgs, ... }:

{
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
      settings = builtins.fromTOML (builtins.readFile ./starship/config.toml);
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
        functionsDir = "${builtins.getEnv "HOME"}/${config.programs.zsh.dotDir}/functions";
      in
      ''
        for conf in "${functionsDir}"/**/*.zsh; do
          source "$conf"
        done
      '';

      envExtra = ''
        export PATH="$PATH:${config.xdg.dataHome}/krew/bin"
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
          src = pkgs.zsh-nix-shell;
          file = "nix-shell.plugin.zsh";
        }
      ];
      shellAliases = {
        # switch between yubikeys for the same GPG key
        cat = "bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)";
        switch_yubikeys="gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";
      };
      history = {
        path = "${config.xdg.configHome}/zsh/history";
      };
    };
  };

  xdg.configFile = {
    "lsd" = {
      source = config.lib.file.mkOutOfStoreSymlink ./lsd/themes;
      recursive = true;
    };
    "zsh/functions" = {
      source = config.lib.file.mkOutOfStoreSymlink ./zsh/functions;
      recursive = true;
    };
  };
}