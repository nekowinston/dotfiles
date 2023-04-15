{
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc.automatic = true;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      auto-optimise-store = pkgs.stdenv.isLinux;
      substituters = [
        "https://catppuccin.cachix.org"
        "https://mic92.cachix.org"
        "https://nekowinston.cachix.org"
        "https://nix-community.cachix.org"
        "https://pre-commit-hooks.cachix.org"
      ];
      # configuration.nix
      trusted-public-keys = [
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
        "mic92.cachix.org-1:gi8IhgiT3CYZnJsaW7fxznzTkMUOn1RY4GmXdT/nXYQ="
        "nekowinston.cachix.org-1:lucpmaO+JwtoZj16HCO1p1fOv68s/RL1gumpVzRHRDs="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      ];
    };
  };
}
