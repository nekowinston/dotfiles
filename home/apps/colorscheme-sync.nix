{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;

  vividCatppuccin = pkgs.runCommand "vivid-catppuccin" { nativeBuildInputs = [ pkgs.vivid ]; } ''
    mkdir -p $out
    for flavor in mocha macchiato frappe latte; do
      vivid generate "catppuccin-''${flavor}" > "$out/''${flavor}"
    done
  '';
in
{
  config = lib.mkIf config.isGraphical {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "dark-mode-ternary";
        runtimeInputs = lib.optionals isLinux [
          pkgs.dbus
          pkgs.gnugrep
        ];
        text =
          let
            queryCommand =
              if isLinux then
                "dbus-send --session --print-reply=literal --reply-timeout=5 --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:'org.freedesktop.appearance' string:'color-scheme' | grep -q 'uint32 1'"
              else if isDarwin then
                "defaults read -g AppleInterfaceStyle &>/dev/null"
              else
                throw "Unsupported platform";
          in
          ''
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
        lng = config.location.longitude;
        useGeoclue = false;
      };
      lightModeScripts = {
        gtk-theme = ''
          ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        '';
      };
    };

    programs.zsh.initExtra = ''
      zadm_sync() {
        local flavor="$(dark-mode-ternary mocha latte)"

        export BAT_THEME="Catppuccin ''${(C)flavor}"
        export LS_COLORS="$(cat "${vividCatppuccin}/''${flavor}")"
        export STARSHIP_CONFIG__PALETTE="catppuccin_''${flavor}"

        fast-theme "XDG:catppuccin-''${flavor}" >/dev/null
      }
      add-zsh-hook precmd zadm_sync
    '';
    programs.nushell.extraConfig = ''
      $env.config = ($env.config? | default {})
      $env.config.hooks = ($env.config.hooks? | default {})
      $env.config.hooks.pre_prompt = (
        $env.config.hooks.pre_prompt?
        | default []
        | append {||
          let flavor = dark-mode-ternary "mocha" "latte"

          $env.config.color_config = (catppuccin $flavor)
          $env.BAT_THEME = "Catppuccin " + ($flavor | str capitalize)
          $env.STARSHIP_CONFIG__PALETTE = "catppuccin_" + $flavor
          $env.LS_COLORS = (cat $"${vividCatppuccin}/($flavor)")
        }
      )
    '';
  };
}
