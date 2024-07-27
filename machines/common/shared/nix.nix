{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (builtins) attrValues mapAttrs;
  inherit (lib) filterAttrs;
  inherit (pkgs.stdenv) isDarwin isLinux;
  flakeInputs = filterAttrs (name: value: (value ? outputs) && (name != "self")) inputs;
in
{
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc.automatic = true;
    settings = {
      # breaks the Nix Store on macOS
      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = isLinux;
      experimental-features = [
        "auto-allocate-uids"
        "flakes"
        "nix-command"
      ];
      trusted-users = [
        "@sudo"
        "@wheel"
        "winston"
      ];
      use-xdg-base-directories = true;
      warn-dirty = false;
    } // (import ../../../flake.nix).nixConfig;
    registry = mapAttrs (name: v: { flake = v; }) flakeInputs;
    nixPath =
      if isDarwin then
        lib.mkForce (mapAttrs (k: v: v.outPath) flakeInputs)
      else if isLinux then
        attrValues (mapAttrs (k: v: "${k}=${v.outPath}") flakeInputs)
      else
        throw "Unsupported platform";
  };
}
