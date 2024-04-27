{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;

  vividBuilder = flavor:
    pkgs.runCommand "vivid-${flavor}" {
      nativeBuildInputs = [pkgs.vivid];
    } ''
      vivid generate ${pkgs.vivid.src}/themes/catppuccin-${flavor}.yml > $out
    '';
  vividLatte = vividBuilder "latte";
  vividMocha = vividBuilder "mocha";
in {
  config = lib.mkIf config.isGraphical {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "dark-mode-ternary";
        runtimeInputs = lib.optionals isLinux [pkgs.dbus pkgs.gnugrep];
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
      initExtra = ''
        zadm_sync() {
          BAT_THEME="Catppuccin $(dark-mode-ternary Mocha Latte)"
          LS_COLORS="$(cat $(dark-mode-ternary ${vividMocha} ${vividLatte}))"
          STARSHIP_CONFIG__PALETTE="catppuccin_$(dark-mode-ternary mocha latte)"

          export BAT_THEME LS_COLORS STARSHIP_CONFIG__PALETTE

          fast-theme "XDG:catppuccin-$(dark-mode-ternary mocha latte)" >/dev/null
        }
        add-zsh-hook precmd zadm_sync
      '';
    };
  };
}
