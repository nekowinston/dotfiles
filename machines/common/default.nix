{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc.automatic = true;
    package = pkgs.nixVersions.nix_2_15;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      auto-optimise-store = pkgs.stdenv.isLinux;
      # consider downloaded tarballs as fresh for 7 days
      tarball-ttl = 604800;
    };
  };
}
