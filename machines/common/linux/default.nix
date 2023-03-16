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
}
