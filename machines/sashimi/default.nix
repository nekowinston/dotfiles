{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./brew.nix
  ];

  users.users.winston.home = "/Users/winston";

  networking = let
    name = "sashimi";
  in {
    computerName = name;
    hostName = name;
    localHostName = name;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;
  system.defaults.alf.stealthenabled = 1;

  services = {
    # Auto upgrade nix package and the daemon service.
    nix-daemon.enable = true;
    dnsmasq = {
      enable = true;
      addresses."test" = "127.0.0.1";
      bind = "127.0.0.1";
    };
  };
}
