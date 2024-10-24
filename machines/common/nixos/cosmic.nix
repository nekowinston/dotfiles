{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.desktop == "cosmic") {
    environment = {
      cosmic.excludePackages = [
        pkgs.cosmic-edit
        pkgs.cosmic-term
      ];
      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
    };
  };
}
