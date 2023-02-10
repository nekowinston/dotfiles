{
  config,
  lib,
  options,
  pkgs,
  vscode-utils,
  ...
}:
with lib; let
  cfg = config.catppuccin.vscode;
in {
  options.catppuccin = {
    vscode = {
      enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "Enable catppuccin VS Code theme";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = [(pkgs.callPackage ../packages/vscode-extensions.catppuccin.catppuccin-vsc {})];
    };
  };
}
