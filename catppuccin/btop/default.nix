{ config, lib, options, pkgs, ... }:

with lib; let
  global = config.catppuccin;
  cfg = config.catppuccin.btop;
in

{
  options.catppuccin.btop = {
    enable = mkEnableOption {
      type = types.bool;
      default = false;
      description = "Enable catppuccin btop theme";
    };
    theme = mkOption {
      type = types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = global.defaultTheme;
      description = "Choose a catppuccin btop theme";
    };
  };

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings.color_theme = "catppuccin_${cfg.theme}";
    };
    xdg.configFile."btop/themes/catppuccin_${cfg.theme}.theme" = {
      text = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "btop";
        rev = "ecb8562bb6181bb9f2285c360bbafeb383249ec3";
        sha256 = "sha256-ovVtupO5jWUw6cwA3xEzRe1juUB8ykfarMRVTglx3mk=";
      } + "/catppuccin_${cfg.theme}.theme");
    };
  };
}
