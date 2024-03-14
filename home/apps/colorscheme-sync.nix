{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;

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

  removeHashes = attrs: builtins.mapAttrs (k: v: lib.removePrefix "#" v) attrs;

  fromYAMLfile = f: let
    jsonFile = pkgs.runCommand "in-${f}.json" {nativeBuildInputs = [pkgs.gojq];} ''
      gojq --yaml-input < "${f}" > "$out"
    '';
  in
    builtins.fromJSON (builtins.readFile jsonFile);

  vividYaml = let
    f = flavor: fromYAMLfile "${pkgs.vivid.src}/themes/catppuccin-${flavor}.yml";
  in {
    latte = builtins.toJSON (f "latte");
    mocha = builtins.toJSON (lib.recursiveUpdate (f "mocha") {colors = removeHashes overrides.mocha;});
  };

  vividBuilder = flavor:
    pkgs.runCommand "vivid-${flavor}" {
      nativeBuildInputs = [pkgs.vivid];
    } ''
      echo '${builtins.getAttr flavor vividYaml}' > flavor.yml
      cat ./flavor.yml
      vivid generate ./flavor.yml > $out
    '';
  vividLatte = vividBuilder "latte";
  vividMocha = vividBuilder "mocha";
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
