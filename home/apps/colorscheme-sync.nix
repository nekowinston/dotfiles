{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;

  milspec = (pkgs.callPackage ../../_sources/generated.nix { }).milspec;

  vividMilspec = pkgs.runCommand "vivid-catppuccin" { nativeBuildInputs = [ pkgs.vivid ]; } ''
    mkdir -p $out
    for variant in dark light; do
      vivid generate "${milspec.src}/extras/vivid/milspec-''${variant}.yml" > "$out/''${variant}"
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
                "dbus-send --session --print-reply=literal --reply-timeout=5 --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:'org.freedesktop.appearance' string:'color-scheme' 2>/dev/null | grep -q 'uint32 1'"
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
        usegeoclue = false;
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

    xdg.configFile.fsh.source = "${milspec.src}/extras/zsh-fast-syntax-highlighting";
    programs.zsh.initExtra = ''
      zadm_sync() {
        local flavor="$(dark-mode-ternary mocha latte)"
        local variant="$(dark-mode-ternary dark light)"

        export BAT_THEME="Catppuccin ''${(C)flavor}"
        export LS_COLORS="$(cat "${vividMilspec}/''${variant}")"
        export STARSHIP_CONFIG__PALETTE="milspec_''${variant}"

        fast-theme "XDG:milspec-''${variant}" >/dev/null
      }
      add-zsh-hook precmd zadm_sync
    '';

    programs.nushell.extraConfig = ''
      use ${milspec.src}/extras/nu/milspec.nu

      $env.config = ($env.config? | default {})

      $env.config.color_config = (milspec -R dark)

      $env.config.hooks = ($env.config.hooks? | default {})
      $env.config.hooks.pre_prompt = (
        $env.config.hooks.pre_prompt?
        | default []
        | append {||
          let flavor = dark-mode-ternary "mocha" "latte"
          let variant = dark-mode-ternary "dark" "light"

          $env.config.color_config = (milspec -R $variant)
          $env.BAT_THEME = "Catppuccin " + ($flavor | str capitalize)
          $env.STARSHIP_CONFIG__PALETTE = "milspec_" + $variant
          $env.LS_COLORS = (cat $"${vividMilspec}/($variant)")
        }
      )
    '';
  };
}
