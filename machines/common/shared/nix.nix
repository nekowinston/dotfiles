{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc.automatic = true;
    package = pkgs.nixVersions.nix_2_16;
    settings = {
      auto-optimise-store = pkgs.stdenv.isLinux;
      experimental-features = [
        "auto-allocate-uids"
        "flakes"
        "nix-command"
        "repl-flake"
      ];
      tarball-ttl = 604800;
      trusted-users = ["@staff" "@sudo" "@wheel"];
      warn-dirty = false;
    };
  };
}
