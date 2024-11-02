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
    ./input.nix
    ./network.nix
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
  environment.systemPackages = [ pkgs.xdg-utils ];

  # enable yubikey u2f support
  security.pam.u2f = {
    enable = true;
    settings.cue = true;
  };
}
