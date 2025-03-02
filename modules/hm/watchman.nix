{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.watchman;

  inherit (lib) mkEnableOption mkPackageOption;
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  options.services.watchman = {
    enable = mkEnableOption "watchman service";
    package = mkPackageOption pkgs "watchman" { };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];
      sessionVariables =
        lib.optionalAttrs isLinux {
          WATCHMAN_SOCK = "$XDG_RUNTIME_DIR/watchman.sock";
        }
        // lib.optionalAttrs isDarwin {
          WATCHMAN_SOCK = "/tmp/watchman.${config.home.username}.sock";
        };
    };
  };
}
