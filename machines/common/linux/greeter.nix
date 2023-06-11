{
  config,
  lib,
  pkgs,
  ...
}: let
  catppuccin-gtk = pkgs.catppuccin-gtk.overrideAttrs (final: rec {
    version = "0.6.0";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "gtk";
      rev = "v${version}";
      sha256 = "sha256-3HplAmlj8hK9Myy8mgvR88sMa2COmYAU75Fk1JuKtMc=";
    };
  });
  greetdConfig = pkgs.writeText "greetd-config" ''
    output "*" {
      scale 2
    }
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
        icon_theme_name = "Papirus";
        theme_name = "Catppuccin-Mocha-Compact-Pink-Dark";
      };
    };
  };
  services.greetd.settings.default_session.command = "${lib.getExe config.programs.sway.package} --config ${greetdConfig}";
  services.gnome.gnome-keyring.enable = true;

  security.pam = {
    u2f = {
      enable = true;
      cue = true;
    };
    services.greetd = {
      enableGnomeKeyring = true;
      u2fAuth = true;
    };
  };
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
    (catppuccin-gtk.override {
      accents = ["pink"];
      variant = "mocha";
      size = "compact";
    })
    (catppuccin-gtk.override {
      accents = ["pink"];
      variant = "latte";
      size = "compact";
    })
    (catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "pink";
    })
    (catppuccin-papirus-folders.override {
      flavor = "latte";
      accent = "pink";
    })
    numix-cursor-theme
    # nur.repos.nekowinston.posy-improved-cursor
  ];
}
