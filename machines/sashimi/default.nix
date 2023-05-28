{
  imports = [
    ./brew.nix
  ];

  users.users.winston.home = "/Users/winston";

  networking = let
    name = "sashimi";
  in {
    computerName = name;
    hostName = name;
  };

  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;
  system.defaults.alf.stealthenabled = 1;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
}
