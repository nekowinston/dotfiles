{
  config,
  lib,
  pkgs,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  users.users.winston.home = "/Users/winston";

  imports = [
    ./brew.nix
    ./wm.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;
  system.defaults.alf.stealthenabled = 1;

  services = {
    dnsmasq = {
      enable = true;
      addresses."test" = "127.0.0.1";
      bind = "127.0.0.1";
    };
  };
}
