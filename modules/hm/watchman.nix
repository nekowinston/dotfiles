# TODO: macOS launchd implementation
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.watchman;

  inherit (lib) mkEnableOption mkPackageOption;
  inherit (pkgs.stdenv) isLinux;
in
{
  options.services.watchman = {
    enable = mkEnableOption "watchman service";
    package = mkPackageOption pkgs "watchman" { };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];
      sessionVariables = lib.mkIf isLinux {
        WATCHMAN_SOCK = "$XDG_RUNTIME_DIR/watchman.sock";
      };
    };

    # see https://github.com/facebook/watchman/commit/2985377eaf8c8538b28fae9add061b67991a87c2
    systemd.user = lib.mkIf isLinux {
      sockets.watchman = {
        Unit.Description = "Watchman socket";
        Socket = {
          Accept = false;
          ListenStream = "%t/watchman.sock";
          SocketMode = "0664";
        };
        Install.WantedBy = [ "sockets.target" ];
      };

      services.watchman = {
        Unit.Description = "Watchman service";
        Service = {
          ExecStart = lib.concatStringsSep " " [
            (lib.getExe cfg.package)
            "--foreground"
            "--inetd"
            "--unix-listener-path"
            config.systemd.user.sockets.watchman.Socket.ListenStream
          ];
          Restart = "on-failure";
          StandardInput = "socket";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
