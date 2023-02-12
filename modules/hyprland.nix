{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  nvidiaPrefix = "GDM_BACKEND=nvidia-drm LIBVA_DRIVER_NAME=nvidia __GLX_VENDOR_LIBRARY_NAME=nvidia WLR_NO_HARDWARE_CURSORS=1";
  waylandPrefix = "XDG_SESSION_TYPE=wayland NIXOS_OZONE_WL=1";
in {
  home.shellAliases = lib.mkIf isLinux {
    "Hyprland" = "${nvidiaPrefix} ${waylandPrefix} Hyprland";
    "sway" = "${nvidiaPrefix} ${waylandPrefix} sway";
  };
  wayland = lib.mkIf isLinux {
    windowManager = {
      sway = {
        enable = true;
        extraOptions = ["--unsupported-gpu"];
        config = {
          modifier = "Mod4";
          keybindings = let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in
            lib.mkOptionDefault {
              "${modifier}+Shift+Return" = "exec ${lib.getExe pkgs.wezterm}-gui";
              "${modifier}+Shift+q" = "kill";
              "${modifier}+space" = "exec ${lib.getExe pkgs.rofi-wayland} -show drun";
            };
        };
      };
      hyprland = {
        enable = true;
        nvidiaPatches = true;
        xwayland = {
          enable = true;
          hidpi = true;
        };
      };
    };
  };
  xdg = lib.mkIf isLinux {
    configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/modules/hyprland/hyprland.conf";
  };
}
