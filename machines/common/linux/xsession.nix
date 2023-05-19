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
  # needed for gnome3 pinentry
  services.dbus.packages = [pkgs.gcr];
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

  services = {
    # mounting
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;

    # thumbnails
    tumbler.enable = true;

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
}
