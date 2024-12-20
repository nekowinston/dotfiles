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
    environment.systemPackages = with pkgs; [
      # file management
      nautilus
      nautilus-python
      nautilus-open-any-terminal
      # thumbnails
      webp-pixbuf-loader
      ffmpegthumbnailer
    ];
    programs.dconf.enable = true;

    environment.pathsToLink = [ "/share/nautilus-python/extensions" ];
    environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "/var/run/current-system/sw/lib/nautilus/extensions-4";

    programs.file-roller.enable = true;
    programs.sway = {
      enable = true;
      package = if (config.dotfiles.desktop == "swayfx") then pkgs.swayfx else pkgs.sway;
      extraSessionCommands = # bash
        ''
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
        xdg-desktop-portal-gtk
        darkman
      ];
      wlr.enable = true;
      xdgOpenUsePortal = true;
    };

    services = {
      # mounting
      gvfs.enable = true;
      udisks2.enable = true;
      devmon.enable = true;
      # previews
      gnome.sushi.enable = true;
      # search metadata
      gnome.tracker-miners.enable = true;
      # thumbnails
      tumbler.enable = true;
    };
  };
}
