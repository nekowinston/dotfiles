{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.desktop == "sway") {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = lib.concatStringsSep " " [
          "${pkgs.greetd.tuigreet}/bin/tuigreet"
          "--remember"
          "--remember-user-session"
          "--sessions=${config.programs.sway.package}/share/wayland-sessions:${config.programs.hyprland.package}/share/wayland-sessions"
        ];
        user = "greeter";
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
