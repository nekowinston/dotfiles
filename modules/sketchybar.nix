{ config, lib, ... }:

{
  home = lib.mkIf isDarwin {
    packages = [ pkgs.unstable.sketchybar ];
  };
  launchd = lib.mkIf isDarwin {
    agents.sketchybar = {
      enable = true;
      config = {
        ProgramArguments = [ "${lib.getExe pkgs.unstable.sketchybar}" ];
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
