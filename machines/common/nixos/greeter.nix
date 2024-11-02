{
  config,
  lib,
  pkgs,
  ...
}:
let
  isWindowManager = builtins.elem config.dotfiles.desktop [
    "hyprland"
    "sway"
    "swayfx"
  ];
in
{
  config = lib.mkIf isWindowManager {
    services.greetd = {
      enable = true;
      settings.default_session.command = lib.getExe pkgs.greetd.tuigreet;
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
