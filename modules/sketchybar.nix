{ config, pkgs, lib, ... }:

let
  # TODO: remove this once sketchybar is on unstable
  pkgsUnstable = import <nixpkgs-unstable> {};
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in

{
  home = lib.mkIf isDarwin {
    packages = [ pkgsUnstable.sketchybar ];
  };
  launchd = lib.mkIf isDarwin {
    agents.sketchybar = {
      enable = true;
      config = {
        ProgramArguments = [ "${lib.getExe pkgsUnstable.sketchybar}" ];
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Interactive";
        Nice = -20;
      };
    };
  };
  xdg.configFile = lib.mkIf isDarwin {
    "sketchybar" = {
      source = config.lib.file.mkOutOfStoreSymlink ./sketchybar;
      recursive = true;
    };
  };
}
