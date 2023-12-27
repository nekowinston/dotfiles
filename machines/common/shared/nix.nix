{
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) filterAttrs;
  inherit (pkgs.stdenv) isDarwin isLinux;
  flakes = filterAttrs (name: value: value ? outputs) inputs;
in {
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc.automatic = true;
    package = pkgs.nixVersions.nix_2_19;
    settings =
      {
        auto-optimise-store = true;
        experimental-features = ["auto-allocate-uids" "flakes" "nix-command" "repl-flake"];
        trusted-users = ["@sudo" "@wheel" "winston"];
        use-xdg-base-directories = true;
        warn-dirty = false;
      }
      // (import ../../../flake.nix).nixConfig;
    registry = builtins.mapAttrs (name: v: {flake = v;}) flakes;
    nixPath =
      if isDarwin
      then lib.mkForce [{nixpkgs = "${inputs.nixpkgs.outPath}";}]
      else if isLinux
      then ["nixpkgs=${inputs.nixpkgs.outPath}"]
      else throw "Unsupported platform";
  };
}
