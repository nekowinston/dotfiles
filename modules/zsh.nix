{ config, lib, pkgs, machine, ... }:

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
        functionsDir = "${machine.homeDirectory}/${config.programs.zsh.dotDir}/functions";
      in
      ''
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
      source = config.lib.file.mkOutOfStoreSymlink "${machine.flakePath}/modules/lsd/themes";
      recursive = true;
    };
    "zsh/functions" = {
      source = config.lib.file.mkOutOfStoreSymlink "${machine.flakePath}/modules/zsh/functions";
      recursive = true;
    };
  };
}
