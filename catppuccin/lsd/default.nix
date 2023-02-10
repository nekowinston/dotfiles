{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib; let
  global = config.catppuccin;
  cfg = config.catppuccin.btop;
in {
  options.catppuccin.lsd = {
    enable = mkEnableOption {
      type = types.bool;
      default = false;
      description = "Enable catppuccin btop theme";
    };
    theme = mkOption {
      type = types.enum ["mocha" "macchiato" "frappe" "latte"];
      default = global.defaultTheme;
      description = "Choose a catppuccin btop theme";
    };
  };

  config = mkIf cfg.enable {
    programs.lsd = {
      enable = true;
      settings.color_theme = "catppuccin_${cfg.theme}";
    };
  };
}
