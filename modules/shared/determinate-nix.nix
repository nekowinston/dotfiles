{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.determinate-nix;
  inherit (lib.generators) toPretty;

  defaultSystemFeatures =
    [
      "nixos-test"
      "benchmark"
      "big-parallel"
      "kvm"
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform ? gcc.arch) (
      # a builder can run code for `gcc.arch` and inferior architectures
      [ "gccarch-${pkgs.stdenv.hostPlatform.gcc.arch}" ]
      ++ map (x: "gccarch-${x}") (
        lib.systems.architectures.inferiors.${pkgs.stdenv.hostPlatform.gcc.arch} or [ ]
      )
    );
in
{
  options.determinate-nix = {
    enable = lib.mkEnableOption "determinate-nix";
    extraOptions = lib.mkOption {
      default = "";
      description = "Extra verbatim lines in `/etc/nix/nix.custom.conf`";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."nix/nix.custom.conf" =
      let
        mkValueString =
          v:
          if v == null then
            ""
          else if lib.isInt v then
            toString v
          else if lib.isBool v then
            lib.boolToString v
          else if lib.isFloat v then
            lib.strings.floatToString v
          else if lib.isList v then
            toString v
          else if lib.isDerivation v then
            toString v
          else if builtins.isPath v then
            toString v
          else if lib.isString v then
            v
          else if lib.isCoercibleToString v then
            toString v
          else
            abort "The nix conf value: ${toPretty { } v} can not be encoded";

        mkKeyValue = k: v: "${lib.escape [ "=" ] k} = ${mkValueString v}";

        mkKeyValuePairs = attrs: lib.concatStringsSep "\n" (lib.mapAttrsToList mkKeyValue attrs);

        isExtra = key: lib.hasPrefix "extra-" key;

        nixSettings = config.nix.settings;
      in
      {
        text = ''
          # WARNING: this file is generated from the nix.* options in
          # your nix-darwin configuration. Do not edit it!
          ${mkKeyValuePairs (lib.filterAttrs (key: value: !(isExtra key)) nixSettings)}
          ${mkKeyValuePairs (lib.filterAttrs (key: value: isExtra key) nixSettings)}
          ${cfg.extraOptions}
        '';
      };

    nix = {
      # let the Determinate system installer manage /etc/nix/nix.conf
      enable = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (lib.mkForce false);

      # https://github.com/NixOS/nixpkgs/blob/da044451c6a70518db5b730fe277b70f494188f1/nixos/modules/config/nix.nix#L376-L388
      settings = {
        substituters = lib.mkAfter [ "https://cache.nixos.org/" ];
        system-features = lib.mkDefault defaultSystemFeatures;
        trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
        trusted-users = [ "root" ];
      };
    };
  };
}
