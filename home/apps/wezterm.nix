{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}:
let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/wezterm/${path}";
  srcs = pkgs.callPackage ../../_sources/generated.nix { };
in
{
  # use the GUI version & config when we have a gui, else just get terminfo
  config = lib.mkMerge [
    (lib.mkIf (!config.isGraphical) { home.packages = [ pkgs.wezterm.terminfo ]; })

    (lib.mkIf config.isGraphical {
      programs.wezterm = {
        # TODO: broken, again
        enable = true;
        package = lib.mkIf pkgs.stdenv.isLinux pkgs.wezterm-nightly;
      };

      xdg.configFile = {
        "wezterm/wezterm.lua".source = mkSymlink "wezterm.lua";
        "wezterm/config".source = mkSymlink "config";
        "wezterm/bar".source = srcs.nekowinston-wezterm-bar.src;
        "wezterm/milspec".source = srcs.milspec.src + "/extras/wezterm";
      };
    })
  ];
}
