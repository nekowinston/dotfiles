{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  srcs = pkgs.callPackage ../../_sources/generated.nix { };
  zshPlugins =
    plugins:
    (map (plugin: rec {
      name = src.name;
      inherit (plugin) file src;
    }) plugins);
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    initExtraFirst = ''
      zvm_config() {
        ZVM_INIT_MODE=sourcing
        ZVM_CURSOR_STYLE_ENABLED=false
        ZVM_VI_HIGHLIGHT_BACKGROUND=black
        ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold,underline
        ZVM_VI_HIGHLIGHT_FOREGROUND=white
      }
    '';
    initExtra =
      ''
        function incognito() {
          if [[ -n $ZSH_INCOGNITO ]]; then
            add-zsh-hook precmd _atuin_precmd
            add-zsh-hook preexec _atuin_preexec
            unset ZSH_INCOGNITO
          else
            add-zsh-hook -d precmd _atuin_precmd
            add-zsh-hook -d preexec _atuin_preexec
            export ZSH_INCOGNITO=1
          fi
        }

        onefetch_in_git_dir() {
          if [[ -d '.git' ]]; then
            ${pkgs.onefetch}/bin/onefetch --no-merges --no-bots --no-color-palette --text-colors 1 1 3 4 4
          fi
        }

        add-zsh-hook chpwd onefetch_in_git_dir
      ''
      + lib.optionalString isLinux ''
        function open() {
          nohup xdg-open "$*" > /dev/null 2>&1
        }
      '';

    dotDir = ".config/zsh";
    oh-my-zsh = {
      enable = true;
      plugins =
        [
          "colored-man-pages"
          "colorize"
          "git"
          "kubectl"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          "dash"
          "macos"
        ];
    };
    plugins = zshPlugins [
      {
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        src = pkgs.zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
      {
        src = pkgs.zsh-fast-syntax-highlighting.overrideAttrs (_: {
          src = srcs.zsh-fast-syntax-highlighting.src;
        });
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
    ];
    sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
    shellAliases = {
      cat = "bat";

      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      lt = "eza -T";
      lla = "eza -la";
      llt = "eza -lT";

      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
    };
    history.path = "${config.xdg.configHome}/zsh/history";
  };
}
