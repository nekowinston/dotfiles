{
  imports = [
    ./brew.nix
    ../common/darwin
  ];

  users.users.winston.home = "/Users/winston";
  networking.computerName = "sashimi";
  networking.hostName = "sashimi";
}
