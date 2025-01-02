{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  home = {
    packages = [ pkgs.onefetch ];
    sessionVariables.LESS = "-i -R --use-color";
    shellAliases = {
      # switch between yubikeys for the same GPG key
      switch_yubikeys = ''gpg-connect-agent "scd serialno" "learn --force" "/bye"'';

      # podman
      docker = lib.mkIf isLinux "podman";
      docker-compose = lib.mkIf isLinux "podman-compose";
    };
  };

  programs = {
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        inline_height = 30;
        style = "compact";
        sync_address = "https://atuin.winston.sh";
        sync_frequency = "5m";
      };
    };
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

    eza = {
      enable = true;
      icons = "auto";
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
      defaultOptions = [
        "--height=30%"
        "--layout=reverse"
        "--info=inline"
      ];
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
  };
}
