{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./gnome.nix
    ./greeter.nix
    ./input.nix
    ./network.nix
    ./sound.nix
    ./sway.nix
  ];

  console.colors = [
    "1e1e2e"
    "585b70"

    "bac2de"
    "a6adc8"

    "f38ba8"
    "f38ba8"

    "a6e3a1"
    "a6e3a1"

    "f9e2af"
    "f9e2af"

    "89b4fa"
    "89b4fa"

    "f5c2e7"
    "f5c2e7"

    "94e2d5"
    "94e2d5"
  ];

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;
  environment.systemPackages = [pkgs.xdg-utils];

  # enable yubikey u2f support
  security.pam.u2f = {
    enable = true;
    cue = true;
  };
}
