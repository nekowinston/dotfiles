{pkgs, ...}: {
  imports = [
    ./shared
  ];
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc.automatic = true;
    package = pkgs.nixVersions.nix_2_15;
    settings = {
      experimental-features = [
        "auto-allocate-uids"
        "flakes"
        "nix-command"
        "repl-flake"
      ];
      auto-optimise-store = pkgs.stdenv.isLinux;
    };
  };
}
