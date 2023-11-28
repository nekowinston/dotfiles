{
  config,
  lib,
  pkgs,
  ...
}: let
  # TODO: de-duplicate across modules
  lat = 48.210033;
  lng = 16.363449;
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

    services.darkman = let
      starship = "${config.programs.starship.package}/bin/starship";
      zsh = "${config.programs.zsh.package}/bin/zsh";
    in {
      enable = isLinux;
      settings = {
        inherit lat lng;
        useGeoclue = false;
      };
      darkModeScripts = {
        toggle-shell = ''
          ${starship} config palette catppuccin_mocha
          ${zsh} -ic "fast-theme XDG:catppuccin-mocha"
        '';
      };
      lightModeScripts = {
        toggle-shell = ''
          ${starship} config palette catppuccin_latte
          ${zsh} -ic "fast-theme XDG:catppuccin-latte"
        '';
      };
    };

    programs.zsh.shellAliases.cat = "bat --theme=$(dark-mode-ternary 'Catppuccin-mocha' 'Catppuccin-latte')";
  };
}
