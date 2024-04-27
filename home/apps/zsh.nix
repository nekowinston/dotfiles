{
  config,
  lib,
  pkgs,
  ...
}: let
  srcs = pkgs.callPackage ../../_sources/generated.nix {};
  zshPlugins = plugins: (map (plugin: rec {
      name = src.name;
      inherit (plugin) file src;
    })
    plugins);
in {
  home.sessionVariables = {
    LESS = "-R --use-color";
    LESSHISTFILE = "-";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  programs = {
    atuin = {
      enable = true;
      flags = ["--disable-up-arrow"];
      settings = {
        inline_height = 30;
        style = "compact";
        sync_address = "https://atuin.winston.sh";
        sync_frequency = "5m";
      };
    };
    bat = {
      enable = true;
      themes = {
        "Catppuccin Latte" = {
          src = "${srcs.catppuccin-bat.src}/themes";
          file = "Catppuccin Latte.tmTheme";
        };
        "Catppuccin Frappe" = {
          src = "${srcs.catppuccin-bat.src}/themes";
          file = "Catppuccin Frappe.tmTheme";
        };
        "Catppuccin Macchiato" = {
          src = "${srcs.catppuccin-bat.src}/themes";
          file = "Catppuccin Macchiato.tmTheme";
        };
        "Catppuccin Mocha" = {
          src = "${srcs.catppuccin-bat.src}/themes";
          file = "Catppuccin Mocha.tmTheme";
        };
      };
    };
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
      };
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    eza = {
      enable = true;
      icons = true;
      extraOptions = [
        "--group"
        "--group-directories-first"
        "--no-permissions"
        "--octal-permissions"
      ];
    };

    fzf = {
      enable = true;
      colors = {
        fg = "#cdd6f4";
        "fg+" = "#cdd6f4";
        hl = "#f38ba8";
        "hl+" = "#f38ba8";
        header = "#ff69b4";
        info = "#cba6f7";
        marker = "#f5e0dc";
        pointer = "#f5e0dc";
        prompt = "#cba6f7";
        spinner = "#f5e0dc";
      };
      defaultOptions = ["--height=30%" "--layout=reverse" "--info=inline"];
    };

    less.enable = true;

    nix-index-database.comma.enable = true;

    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship/config.toml);
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
      initExtra = ''
        for script in "${./zsh/functions}"/**/*; do source "$script"; done
      '';

      dotDir = ".config/zsh";
      oh-my-zsh = {
        enable = true;
        plugins =
          ["colored-man-pages" "colorize" "git" "kubectl"]
          ++ lib.optionals pkgs.stdenv.isDarwin ["dash" "macos"];
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

        # switch between yubikeys for the same GPG key
        switch_yubikeys = ''gpg-connect-agent "scd serialno" "learn --force" "/bye"'';

        # podman
        docker = "podman";
        docker-compose = "podman-compose";
      };
      history.path = "${config.xdg.configHome}/zsh/history";
    };
  };

  xdg.configFile."fsh".source = "${srcs.catppuccin-zsh-fsh.src}/themes";
}
