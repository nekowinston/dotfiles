{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.desktop == "sway") {
    environment.systemPackages = with pkgs; [
      # file management
      p7zip
      unzip
      zip
      file-roller
      nautilus
      nautilus-python
      sushi
      nautilus-open-any-terminal

      # thumbnails
      webp-pixbuf-loader
      ffmpegthumbnailer
    ];
    programs.dconf.enable = true;

    environment.pathsToLink = [ "/share/nautilus-python/extensions" ];
    environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";

    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      extraPackages = with pkgs; [
        swaylock-effects
        swayidle
      ];
      extraSessionCommands = ''
        # session
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
        # wayland
        export NIXOS_OZONE_WL=1
        export MOZ_ENABLE_WAYLAND=1
        export QT_QPA_PLATFORM=wayland
        export SDL_VIDEODRIVER=wayland
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
      config.sway = {
        "org.freedesktop.impl.portal.Settings" = [ "darkman" ];
      };
      extraPortals = with pkgs; [
        darkman
        xdg-desktop-portal-gtk
      ];
      wlr.enable = true;
      xdgOpenUsePortal = true;
    };

    services = {
      # mounting
      gvfs.enable = true;
      udisks2.enable = true;
      devmon.enable = true;
      gnome.sushi.enable = true;
      gnome.tracker-miners.enable = true;

      # thumbnails
      tumbler.enable = true;
    };
  };
}
