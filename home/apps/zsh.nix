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
  overrides = {
    mocha = {
      rosewater = "#ece3e1";
      flamingo = "#e1d2d2";
      pink = "#ddccd8";
      mauve = "#bbb2c9";
      red = "#c4a2aa";
      maroon = "#cbadb1";
      peach = "#d5beb4";
      yellow = "#ece3d3";
      green = "#b9ddb6";
      teal = "#badad4";
      sky = "#b8d4db";
      sapphire = "#a9c0ce";
      blue = "#aab3c7";
      lavender = "#bfc1d2";
      text = "#d3d6e1";
      subtext1 = "#bec2d2";
      subtext0 = "#a8adc3";
      overlay2 = "#9299b4";
      overlay1 = "#7c84a5";
      overlay0 = "#686f94";
      surface2 = "#555a7b";
      surface1 = "#434664";
      surface0 = "#30314b";
      base = "#101010";
      mantle = "#090909";
      crust = "#080808";
    };
  };
  ctpBat = pkgs.denoPlatform.mkDenoDerivation {
    inherit (srcs.catppuccin-bat) pname version src;
    buildPhase = ''
      deno run -A ./src/main.ts --overrides '${builtins.toJSON overrides}'
    '';
    installPhase = ''
      mkdir -p $out
      cp ./themes/* $out/
    '';
  };
  ctpZshFsh = pkgs.denoPlatform.mkDenoDerivation {
    inherit (srcs.catppuccin-zsh-fsh) pname version src;
    buildPhase = ''
      deno run -A ./build.ts --overrides '${builtins.toJSON overrides}'
    '';
    installPhase = ''
      mkdir -p $out
      cp ./themes/* $out/
    '';
  };
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
          src = ctpBat;
          file = "Catppuccin Latte.tmTheme";
        };
        "Catppuccin Frappe" = {
          src = ctpBat;
          file = "Catppuccin Frappe.tmTheme";
        };
        "Catppuccin Macchiato" = {
          src = ctpBat;
          file = "Catppuccin Macchiato.tmTheme";
        };
        "Catppuccin Mocha" = {
          src = ctpBat;
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

  xdg.configFile."fsh".source = "${ctpZshFsh}";
}
