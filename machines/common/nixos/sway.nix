{
  config,
  lib,
  pkgs,
  ...
}:
let
  condition = (
    builtins.elem config.dotfiles.desktop [
      "sway"
      "swayfx"
    ]
  );
in
{
  config = lib.mkIf condition {
    environment = {
      systemPackages = with pkgs; [
        # file management
        nautilus
        nautilus-python
        nautilus-open-any-terminal
        # screen recording
        gpu-screen-recorder-gtk
      ];
      pathsToLink = [ "/share/nautilus-python/extensions" ];
      sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
    };

    programs.dconf.enable = true;
    programs.file-roller.enable = true;
    programs.gpu-screen-recorder.enable = true;

    programs.sway = {
      enable = true;
      package = if (config.dotfiles.desktop == "swayfx") then pkgs.swayfx else pkgs.sway;
      extraPackages = with pkgs; [ brightnessctl ];
      extraSessionCommands = # bash
        ''
          # session
          export XDG_SESSION_TYPE=wayland
          export XDG_SESSION_DESKTOP=sway
          export XDG_CURRENT_DESKTOP=sway
          # wayland
          export NIXOS_OZONE_WL=1
          export QT_QPA_PLATFORM="wayland;xcb"
          export SDL_VIDEODRIVER="wayland,x11"
          export _JAVA_AWT_WM_NONREPARENTING=1
        '';
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
    };

    services.dbus.packages = with pkgs; [
      darkman
      nautilus-open-any-terminal
    ];
    xdg.portal = {
      enable = true;
      config = {
        common.default = [ "gtk" ];
        sway = {
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.Settings" = [ "darkman" ];
        };
      };
      extraPortals = with pkgs; [
        darkman
        xdg-desktop-portal-gtk
      ];
      wlr.enable = true;
      xdgOpenUsePortal = true;
    };

    services = {
      # mounting and fs support
      gvfs.enable = true;
      udisks2.enable = true;
      # previews
      gnome.sushi.enable = true;
      # search metadata
      gnome.localsearch.enable = true;
    };
  };
}
