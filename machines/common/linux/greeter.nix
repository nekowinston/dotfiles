{
  config,
  lib,
  pkgs,
  ...
}:
let
  condition = (
    builtins.elem config.dotfiles.desktop [
      "hyprland"
      "sway"
    ]
  );
in
{
  config = lib.mkIf condition {
    programs.regreet = {
      enable = true;
      settings = {
        background = {
          path = ../../../home/wallpapers/dhm_1610.png;
          fit = "Cover";
        };
        GTK = {
          cursor_theme_name = "macOS-Monterey";
          font_name = "IBM Plex Sans 16";
          icon_theme_name = "WhiteSur";
          theme_name = "WhiteSur-Dark";
        };
      };
      font.name = "IBM Plex Sans";
      cursorTheme = {
        name = "macOS-Monterey";
        package = pkgs.apple-cursor;
      };
      iconTheme = {
        name = "WhiteSur-Dark";
        package = pkgs.whitesur-icon-theme;
      };
      theme = {
        name = "WhiteSur-Dark";
        package = pkgs.whitesur-gtk-theme;
      };
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      u2fAuth = true;
    };
    security.polkit.enable = true;

    # start a keyring daemon for sway
    systemd = {
      packages = [ pkgs.polkit_gnome ];
      user.services.polkit-gnome-authentication-agent-1 = {
        unitConfig = {
          Description = "polkit-gnome-authentication-agent-1";
          Wants = [ "graphical-session.target" ];
          WantedBy = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
