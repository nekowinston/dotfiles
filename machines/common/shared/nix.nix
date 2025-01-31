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
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "1password"
        "1password-cli"
        "discord"
        "steam"
        "steam-unwrapped"
        "uhk-agent"
        "uhk-udev-rules"
        "xkcd-font"
        # firefox extensions
        "languagetool"
        "onepassword-password-manager"
      ];
    # prefer my own registry & path pinning for *all* inputs
    flake.setNixPath = false;
    flake.setFlakeRegistry = false;
  };

  nix = {
    gc =
      {
        automatic = true;
      }
      // lib.optionalAttrs isDarwin {
        interval = {
          Weekday = 0;
          Hour = 0;
          Minute = 0;
        };
      }
      // lib.optionalAttrs isLinux {
        dates = "weekly";
      };
    settings = {
      # breaks the Nix Store on macOS
      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = isLinux;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      trusted-users = [ config.dotfiles.username ];
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
