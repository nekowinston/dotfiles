let
  nvidiaPrefix = "GDM_BACKEND=nvidia-drm LIBVA_DRIVER_NAME=nvidia __GLX_VENDOR_LIBRARY_NAME=nvidia WLR_NO_HARDWARE_CURSORS=1";
in {
  environment.shellAliases = {
    nvidia = "${nvidiaPrefix} Hyprland";
  };
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    nvidiaPatches = true;
  };
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
}
