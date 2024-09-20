{ lib, config, ... }:
{
  config = lib.mkIf (config.dotfiles.desktop == "cosmic") {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
    };
  };
}
