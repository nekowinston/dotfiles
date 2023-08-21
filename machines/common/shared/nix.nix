{
  lib,
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc.automatic = true;
    package = pkgs.nixVersions.nix_2_16;
    settings =
      {
        auto-optimise-store = pkgs.stdenv.isLinux;
        experimental-features = ["auto-allocate-uids" "flakes" "nix-command" "repl-flake"];
        trusted-users = ["@staff" "@sudo" "@wheel"];
        use-xdg-base-directories = true;
        warn-dirty = false;
      }
      // ((import ../../../flake.nix).nixConfig);
  };

  # set nixPath to the flake nixpkgs without channels
  environment.variables.NIX_PATH = lib.mkForce "nixpkgs=${inputs.nixpkgs.outPath}";
}
