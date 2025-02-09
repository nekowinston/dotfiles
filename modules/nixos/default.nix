{
  imports = [
    ./gaming.nix
    ./orbstack.nix
    ./wsl.nix
  ];

  system.rebuild.enableNg = true;
}
