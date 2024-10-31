{ lib, osConfig, ... }:
let
  inherit (lib) types mkOption;

  # inherit from nixos
  osOptions = (import ../shared/config.nix { inherit lib; }).options;
in
{
  options = {
    isGraphical = osOptions.isGraphical // {
      default = osConfig.isGraphical;
    };
    location = {
      latitude = mkOption {
        default = osConfig.location.latitude;
        type = types.nullOr types.float;
      };
      longitude = mkOption {
        default = osConfig.location.longitude;
        type = types.nullOr types.float;
      };
    };
  };
}
