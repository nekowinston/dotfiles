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

    kanata = {
      enable = true;
      package = pkgs.master.kanata;
      keyboards.keychron-k6 = {
        devices = ["/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd"];
        config = ''
          (defsrc
            esc   1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab   q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps  a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft  z    x    c    v    b    n    m    ,    .    /    rsft
            lctl  lmet lalt           spc            ralt rmet rctl)
          (deflayer qwerty
            @sesc 1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab   q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps  a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft  z    x    c    v    b    n    m    ,    .    /    rsft
            lctl  lmet lalt           spc            ralt rmet rctl)

          (defalias
            sesc (fork esc grv (lsft rsft))
          )
        '';
      };
    };

    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      displayManager = {
        gdm.enable = true;
        # one of these days, it'll be sway :COPIUM:
        defaultSession = "none+i3";
      };
      libinput.enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.unstable.i3;
      };
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
