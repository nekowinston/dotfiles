{
  config,
  lib,
  pkgs,
  ...
}: let
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
  };
  catppuccin-zsh-fsh = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "zsh-fsh";
    rev = "7cdab58bddafe0565f84f6eaf2d7dd109bd6fc18";
    sha256 = "sha256-31lh+LpXGe7BMZBhRWvvbOTkwjOM77FPNaGy6d26hIA=";
  };
  zshPlugins = plugins: (map (plugin: rec {
      name = src.name;
      inherit (plugin) file src;
    })
    plugins);
in {
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
        "Catppuccin-latte" = {
          src = catppuccin-bat;
          file = "Catppuccin-latte.tmTheme";
        };
        "Catppuccin-frappe" = {
          src = catppuccin-bat;
          file = "Catppuccin-frappe.tmTheme";
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

    lsd = {
      enable = true;
      enableAliases = true;
      settings = {
        classic = false;
        blocks = ["permission" "user" "group" "size" "date" "name"];
        date = "+%y.%m.%d %H:%M";
        dereference = false;
        ignore-globs = [".git"];
        color = {
          when = "auto";
          theme = "custom";
        };
        icons = {
          when = "auto";
          theme = "fancy";
          separator = " ";
        };
        header = false;
        hyperlink = "auto";
        indicators = true;
        layout = "grid";
        permission = "octal";
        size = "default";
        sorting = {
          column = "name";
          dir-grouping = "first";
        };
        symlink-arrow = "󰌷";
      };
    };

    nix-index.enable = true;

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
      enableAutosuggestions = true;
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
      envExtra = ''
        export LESSHISTFILE="-"
      '';

      dotDir = ".config/zsh";
      oh-my-zsh = {
        enable = true;
        plugins =
          ["colored-man-pages" "colorize" "git"]
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
          src = pkgs.zsh-fast-syntax-highlighting.overrideAttrs (old: {
            src = pkgs.fetchFromGitHub {
              inherit (old.src) repo owner;
              rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
              hash = "sha256-RVX9ZSzjBW3LpFs2W86lKI6vtcvDWP6EPxzeTcRZua4=";
            };
          });
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
      ];
      shellAliases = {
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

  xdg.configFile."fsh".source = "${catppuccin-zsh-fsh}/themes";
}
