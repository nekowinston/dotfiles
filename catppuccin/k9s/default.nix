{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib; let
  global = config.catppuccin;
  cfg = config.catppuccin.k9s;
  fromYAML = f: let
    jsonFile =
      pkgs.runCommand "in.json"
      {
        nativeBuildInputs = [pkgs.gojq];
      } ''
        gojq --yaml-input < "${f}" > "$out"
      '';
  in
    builtins.fromJSON (builtins.readFile jsonFile);
in {
  options.catppuccin.k9s = {
    enable = mkEnableOption {
      type = types.bool;
      default = false;
      description = "Enable catppuccin k9s theme";
    };
    theme = mkOption {
      type = types.enum ["mocha" "macchiato" "frappe" "latte"];
      default = global.defaultTheme;
      description = "Choose a catppuccin k9s theme";
    };
  };

  config = mkIf cfg.enable {
    programs.k9s = {
      enable = true;
      skin = fromYAML (pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "k9s";
          rev = "322598e19a4270298b08dc2765f74795e23a1615";
          sha256 = "sha256-GrRCOwCgM8BFhY8TzO3/WDTUnGtqkhvlDWE//ox2GxI=";
        }
        + /dist/${cfg.theme}.yml);
    };
  };
}
