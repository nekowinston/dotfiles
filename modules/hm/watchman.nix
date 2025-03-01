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

    launchd.agents = lib.mkIf isDarwin {
      watchman = {
        enable = true;
        config = {
          ProgramArguments = [
            (lib.getExe cfg.package)
            "--foreground"
            "--unix-listener-path"
            "/tmp/watchman.${config.home.username}.sock"
          ];
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "${config.xdg.cacheHome}/watchman.log";
          StandardErrorPath = "${config.xdg.cacheHome}/watchman.log";
        };
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
