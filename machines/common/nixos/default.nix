{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./boot.nix
    ./cosmic.nix
    ./gnome.nix
    ./greeter.nix
    ./hyprland.nix
    ./network.nix
    ./openssh.nix
    ./podman.nix
    ./sound.nix
    ./sway.nix
  ];

  console.colors = with lib.milspec.dark; [
    bg
    gray
    red
    vermilion
    green
    forest
    orange
    sepia
    blue
    cerulean
    rose
    violet
    cerulean
    turquoise
    fg
    gray
  ];

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = config.isGraphical;
      polkitPolicyOwners = [ config.dotfiles.username ];
    };
    nix-ld.enable = true;
    zsh.enable = true;
  };
  environment.systemPackages =
    with pkgs;
    [
      xdg-utils
    ]
    ++ lib.optionals config.isGraphical [
      # gnome stuff
      baobab
      gnome-disk-utility
      gnome-system-monitor
    ];

  # for pinentry-gnome3
  services.dbus.packages = lib.mkIf config.isGraphical [ pkgs.gcr ];

  # enable yubikey u2f support
  security.pam.u2f = {
    enable = true;
    settings.cue = true;
  };
}
