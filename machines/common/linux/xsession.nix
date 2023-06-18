{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # file management
    p7zip
    unzip
    zip
    gnome.file-roller
    pcmanfm

    # thumbnails
    webp-pixbuf-loader
    ffmpegthumbnailer
  ];
  programs = {
    dconf.enable = true;
    noisetorch.enable = true;
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
  };
}
