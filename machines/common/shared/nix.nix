{
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) filterAttrs;
  flakes = filterAttrs (name: value: value ? outputs) inputs;
in {
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
    registry =
      builtins.mapAttrs
      (name: v: {flake = v;})
      flakes;
    nixPath = [
      {nixpkgs = "${inputs.nixpkgs.outPath}";}
    ];
  };
}
