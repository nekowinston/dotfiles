{ lib, osConfig, ... }:
let
  inherit (lib) types mkOption;

  # inherit from nixos
  osOptions = (import ../shared/config.nix { inherit lib; }).options;

  # stupid option throws an error when accessed instead of allowing null
  latTry = builtins.tryEval (osConfig.location.latitude);
  lonTry = builtins.tryEval (osConfig.location.longitude);
in
{
  options = {
    isGraphical = osOptions.isGraphical // {
      default = osConfig.isGraphical;
    };
    location = {
      latitude = mkOption {
        default = if latTry.success then latTry.value else null;
        type = types.nullOr types.float;
      };
      longitude = mkOption {
        default = if lonTry.success then lonTry.value else null;
        type = types.nullOr types.float;
      };
    };
  };
}
