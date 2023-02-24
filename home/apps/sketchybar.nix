{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  sketchybarPkg = pkgs.unstable.sketchybar;
in {
  home = lib.mkIf isDarwin {
    packages = [sketchybarPkg];
  };
  launchd = lib.mkIf isDarwin {
    agents.sketchybar = {
      enable = true;
      config = {
        ProgramArguments = ["${lib.getExe sketchybarPkg}"];
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Interactive";
        Nice = -20;
        StandardErrorPath = "${config.xdg.cacheHome}/sketchybar.log";
        StandardOutPath = "${config.xdg.cacheHome}/sketchybar.log";
        EnvironmentVariables = {
          LANG = "en_US.UTF-8";
          PATH = "${lib.makeBinPath [
            sketchybarPkg
            pkgs.bash
            pkgs.bc
            pkgs.coreutils
            pkgs.unstable.yabai
          ]}:/usr/bin";
        };
      };
    };
  };
  xdg.configFile = lib.mkIf isDarwin {
    "sketchybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/sketchybar";
      recursive = true;
    };
  };
}
