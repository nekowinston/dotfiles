{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;

  vividBuilder =
    flavor:
    pkgs.runCommand "vivid-${flavor}" { nativeBuildInputs = [ pkgs.vivid ]; } ''
      vivid generate ${pkgs.vivid.src}/themes/catppuccin-${flavor}.yml > $out
    '';
  vividLatte = vividBuilder "latte";
  vividMocha = vividBuilder "mocha";
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
          ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        '';
      };
    };

    programs.zsh.initExtra = ''
      zadm_sync() {
        BAT_THEME="Catppuccin $(dark-mode-ternary Mocha Latte)"
        LS_COLORS="$(cat $(dark-mode-ternary ${vividMocha} ${vividLatte}))"
        STARSHIP_CONFIG__PALETTE="catppuccin_$(dark-mode-ternary mocha latte)"

        export BAT_THEME LS_COLORS STARSHIP_CONFIG__PALETTE

        fast-theme "XDG:catppuccin-$(dark-mode-ternary mocha latte)" >/dev/null
      }
      add-zsh-hook precmd zadm_sync
    '';
    programs.nushell.extraConfig = ''
      def dark-mode-ternary [dark: string, light: string] {
        let system = (uname | get operating-system);

        if ($system == "Darwin") {
          if ((defaults read -g AppleInterfaceStyle e> /dev/null =) == "Dark") {
            $dark
          } else {
            $light
          }
        } else if ($system == "Linux") {
          if ((dbus-send --session --print-reply=literal --reply-timeout=5 --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:'org.freedesktop.appearance' string:'color-scheme' e> /dev/null | str contains "uint32 1")) {
            $dark
          } else {
            $light
          }
        } else {
          $light
        }
      }

      $env.config = ($env.config? | default {})
      $env.config.hooks = ($env.config.hooks? | default {})
      $env.config.hooks.pre_prompt = (
          $env.config.hooks.pre_prompt?
          | default []
          | append [
            { $env.config.color_config = (catppuccin (dark-mode-ternary mocha latte)) }
            { $env.BAT_THEME = $"Catppuccin (dark-mode-ternary Mocha Latte)" }
            { $env.STARSHIP_CONFIG__PALETTE = $"catppuccin_(dark-mode-ternary mocha latte)" }
            { $env.LS_COLORS = (cat (dark-mode-ternary ${vividMocha} ${vividLatte})) }
          ]
      )
    '';
  };
}
