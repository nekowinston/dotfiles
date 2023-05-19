{
  config,
  lib,
  pkgs,
  ...
}: let
  greetdConfig = pkgs.writeText "greetd-config" ''
    exec "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"
    seat seat0 xcursor_theme "Numix-Cursor" 24
    xwayland disable
    exec "${lib.getExe config.programs.regreet.package}; swaymsg exit"
  '';
in {
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ../../../home/wallpapers/dhm_1610.png;
        fit = "Cover";
      };
      GTK = {
        font_name = "IBM Plex Mono 16";
        cursor_theme_name = "Numix-Cursor";
        icon_theme_name = "Papirus-Dark";
        theme_name = "Catppuccin-Mocha-Compact-Pink-Dark";
      };
    };
  };
  services.greetd.settings.default_session.command = "${lib.getExe config.programs.sway.package} --config ${greetdConfig}";
  services.gnome.gnome-keyring.enable = true;

  security.pam.services.greetd.gnupg.enable = true;
  security.polkit.enable = true;
  systemd = {
    packages = [pkgs.polkit_gnome];
    user.services.polkit-gnome-authentication-agent-1 = {
      unitConfig = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = ["graphical-session.target"];
        WantedBy = ["graphical-session.target"];
        After = ["graphical-session.target"];
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
  environment.systemPackages = with pkgs; [
    ((pkgs.catppuccin-gtk.overrideAttrs (final: rec {
        version = "0.5.0";
        src = fetchFromGitHub {
          owner = "catppuccin";
          repo = "gtk";
          rev = "v${version}";
          sha256 = "sha256-tVkB9R3Z4lApCIveWPweTnB/JlwbiVAHREGq+xRINkM=";
        };
      }))
      .override {
        accents = ["pink"];
        variant = "mocha";
        size = "compact";
      })
    (pkgs.nur.repos.nekowinston.papirus-folders-catppuccin.override {
      flavour = "mocha";
      accent = "pink";
    })
    numix-cursor-theme
  ];
}
