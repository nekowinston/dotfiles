{
  imports = [./brew.nix];

  networking.computerName = "sashimi";
  networking.hostName = "sashimi";

  nix.settings.extra-platforms = [
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
