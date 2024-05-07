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
      programs.wezterm.enable = true;

      xdg.configFile = {
        "wezterm/wezterm.lua".source = mkSymlink "wezterm.lua";
        "wezterm/config" = {
          source = mkSymlink "config";
          recursive = true;
        };
        "wezterm/bar".source = srcs.nekowinston-wezterm-bar.src;
        "wezterm/catppuccin".source = srcs.catppuccin-wezterm.src;
      };
    })
  ];
}
