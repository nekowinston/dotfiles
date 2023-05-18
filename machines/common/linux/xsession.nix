{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # file management
    p7zip
    unzip
    zip
    gnome.file-roller

    # thumbnails
    webp-pixbuf-loader
    ffmpegthumbnailer
  ];
  programs = {
    dconf.enable = true;
    noisetorch.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      foot
      swaylock-effects
      swayidle
    ];
  };

  services = {
    # mounting
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;

    greetd = let
      sway-run = pkgs.writeShellScript "sway-run" ''
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

        exec systemd-cat --identifier=sway sway $@
      '';
    in {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --cmd ${sway-run}";
          user = "greeter";
        };
      };
    };

    # thumbnails
    tumbler.enable = true;

    gnome.gnome-keyring.enable = true;

    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      displayManager.startx.enable = true;
      libinput.enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3;
      };
      xkbOptions = "caps:ctrl_modifier";
    };
  };

  # needed for gnome3 pinentry
  services.dbus.packages = [pkgs.gcr];
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

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
}
