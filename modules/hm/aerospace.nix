{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkPackageOption
    ;
  cfg = config.programs.aerospace;
  format = pkgs.formats.toml { };
  configFile = format.generate "aerospace.toml" cfg.settings;
in
{
  options.programs.aerospace = {
    enable = mkEnableOption "aerospace";
    package = mkPackageOption pkgs "aerospace" { };
    settings = mkOption {
      default = { };
      type = types.submodule {
        freeformType = format.type;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation = {
      reloadAerospace =
        lib.hm.dag.entryAfter [ "writeBoundary" ] # bash
          ''
            ${lib.getExe cfg.package} reload-config
          '';
    };
    home.packages = [ cfg.package ];
    xdg.configFile."aerospace/aerospace.toml".source = configFile;
  };
}
