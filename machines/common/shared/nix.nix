{
  config,
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
  nixpkgs = {
    # prefer my own registry & path pinning for *all* inputs
    flake.setNixPath = false;
    flake.setFlakeRegistry = false;
  };

  nix = {
    enable = true;
    channel.enable = false;
    gc = lib.mkIf isLinux {
      automatic = true;
      dates = "weekly";
    };
    optimise = lib.mkIf isLinux {
      automatic = true;
      dates = [ "00:30" ];
    };
    settings = lib.recursiveUpdate (import "${inputs.self.outPath}/flake.nix").nixConfig {
      trusted-users = [ config.dotfiles.username ];
      use-xdg-base-directories = true;
      warn-dirty = false;
    };
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
