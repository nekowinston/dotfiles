{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.location = {
    latitude = mkOption {type = types.nullOr types.float;};
    longitude = mkOption {type = types.nullOr types.float;};
  };
}
