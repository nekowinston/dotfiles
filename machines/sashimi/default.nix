{
  imports = [./brew.nix];

  nix.settings.extra-platforms = [
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  location = {
    latitude = 48.210033;
    longitude = 16.363449;
  };
}
