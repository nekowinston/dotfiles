{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib; let
  global = config.catppuccin;
  cfg = config.catppuccin.dircolors;
  # generated via vivid@HEAD - ./generate.sh
  theme = flavour: trueColor:
    builtins.fromJSON (
      builtins.readFile
      ./catppuccin-${flavour
        + (
          if trueColor
          then ""
          else "-8bit"
        )}.json
    );
in {
  options.catppuccin = {
    dircolors = {
      enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "Enable catppuccin for dircolors / lscolors";
      };
      theme = mkOption {
        type = types.enum ["mocha" "macchiato" "frappe" "latte"];
        default = global.defaultTheme;
        description = "Choose a flavour for dircolors";
      };
      trueColor = mkOption {
        type = types.bool;
        default = true;
        description = "Use truecolor for dircolors";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.dircolors = {
      enable = true;
      settings = theme cfg.theme (!cfg.trueColor);
    };
  };
}
