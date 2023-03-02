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

  services = {
    # mounting
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;

    # thumbnails
    tumbler.enable = true;

    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      displayManager.gdm.enable = true;
      libinput.enable = true;
      windowManager.i3.enable = true;
      xkbOptions = "caps:ctrl_modifier";
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
}
