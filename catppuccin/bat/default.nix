{ config, lib, options, pkgs, ... }:

with lib; let
  global = config.catppuccin;
  cfg = config.catppuccin.bat;
in

{
  options.catppuccin.bat = {
    enable = mkEnableOption {
      type = types.bool;
      default = false;
      description = "Enable catppuccin bat theme";
    };
    theme = mkOption {
      type = types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = global.defaultTheme;
      description = "Choose a catppuccin bat theme";
    };
    activationHook = mkEnableOption {
      type = types.bool;
      default = true;
      description = "Regenerate the bat cache on HM activation";
    };
  };

  config = mkIf cfg.enable {
    home.activation = mkIf cfg.activationHook {
      catppuccinBatCache = "${lib.getExe pkgs.bat} cache --build";
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "Catppuccin-${cfg.theme}";
      };
      themes = let
        getTheme = flavour: builtins.readFile (pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        } + "/Catppuccin-${flavour}.tmTheme");
      in
      {
        Catppuccin-mocha = getTheme "mocha";
        Catppuccin-macchiato = getTheme "macchiato";
        Catppuccin-frappe = getTheme "frappe";
        Catppuccin-latte = getTheme "latte";
      };
    };
  };
}
