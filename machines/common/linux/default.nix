{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./network.nix
    ./sound.nix
    ./xsession.nix
  ];
  # needed for gnome3 pinentry
  services.dbus.packages = [pkgs.gcr];
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

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

  programs.zsh.enable = true;
}
