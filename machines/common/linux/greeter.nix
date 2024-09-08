{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.dotfiles) desktop;
  condition = (
    builtins.elem desktop [
      "hyprland"
      "sway"
      "swayfx"
    ]
  );
  binary =
    {
      swayfx = "sway";
      sway = "sway";
      hyprland = "hypr";
    }
    .${desktop} or (throw "greetd: desktop not supported");
in
{
  config = lib.mkIf condition {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --cmd '${pkgs.dbus}/bin/dbus-run-session ${binary}'";
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
