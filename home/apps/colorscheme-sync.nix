{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  config = lib.mkIf config.isGraphical {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "dark-mode-ternary";
        runtimeInputs = [pkgs.gnugrep];
        text = let
          queryCommand =
            if isLinux
            then "dbus-send --session --print-reply=literal --reply-timeout=5 --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:'org.freedesktop.appearance' string:'color-scheme' | grep -q 'uint32 1'"
            else if isDarwin
            then "defaults read -g AppleInterfaceStyle &>/dev/null"
            else throw "Unsupported platform";
        in ''
          [[ -z "''${1-}" ]] && [[ -z "''${2-}" ]] && echo "Usage: $0 <dark> <light>" && exit 1

          if ${queryCommand}; then
            echo "$1"
          else
            echo "$2"
          fi
        '';
      })
    ];

    services.darkman = {
      enable = isLinux;
      settings = {
        lat = config.location.latitude;
        lon = config.location.longitude;
        useGeoclue = false;
      };
    };

    programs.zsh = {
      shellAliases.cat = "bat --theme=\"$(dark-mode-ternary 'Catppuccin Mocha' 'Catppuccin Latte')\"";
      initExtra = ''
        zadm_sync() {
          export STARSHIP_CONFIG__PALETTE="catppuccin_$(dark-mode-ternary mocha latte)"
          fast-theme "XDG:catppuccin-$(dark-mode-ternary mocha latte)" >/dev/null
        }
        add-zsh-hook precmd zadm_sync
      '';
    };
  };
}
