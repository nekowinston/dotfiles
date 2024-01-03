{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.dotfiles.desktop == "sway") {
    environment.systemPackages = with pkgs; [
      # file management
      p7zip
      unzip
      zip
      gnome.file-roller
      gnome.nautilus
      gnome.nautilus-python
      gnome.sushi
      nautilus-open-any-terminal

      # thumbnails
      webp-pixbuf-loader
      ffmpegthumbnailer
    ];
    programs.dconf.enable = true;

    environment.pathsToLink = ["/share/nautilus-python/extensions"];
    environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";

    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [
        foot
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
      # gcr needed for gnome3 pinentry, managed in Home-Manager
      gcr
    ];
    xdg.portal.enable = true;
    xdg.portal.wlr.enable = true;
    xdg.portal.extraPortals = with pkgs; [
      darkman
      xdg-desktop-portal-gtk
    ];

    services = {
      # mounting
      gvfs.enable = true;
      udisks2.enable = true;
      devmon.enable = true;

      # thumbnails
      tumbler.enable = true;
    };
  };
}