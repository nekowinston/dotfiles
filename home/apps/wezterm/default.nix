{
  config,
  flakePath,
  lib,
  nvfetcherSrcs,
  pkgs,
  ...
}:
let
  mkSymlink =
    path: config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/wezterm/config/${path}";
in
{
  # use the GUI version & config when we have a gui, else just get terminfo
  config = lib.mkMerge [
    (lib.mkIf (!config.isGraphical) {
      home.packages = [ pkgs.wezterm.terminfo ];
    })

    (lib.mkIf config.isGraphical {
      programs.wezterm.enable = true;

      xdg.configFile = {
        "wezterm/wezterm.lua".source = mkSymlink "wezterm.lua";
        "wezterm/config".source = mkSymlink "config";
        "wezterm/bar".source = nvfetcherSrcs.nekowinston-wezterm-bar.src;
        "wezterm/milspec".source = nvfetcherSrcs.milspec.src + "/extras/wezterm";
      };
    })
  ];
}
