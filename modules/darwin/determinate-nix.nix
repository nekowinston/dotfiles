{ config, lib, ... }:
let
  cfg = config.determinate-nix;
  inherit (lib.generators) toPretty;
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

    # let Determinate manage /etc/nix/nix.conf
    nix = {
      enable = lib.mkForce false;
      settings = {
        substituters = lib.mkAfter [ "https://cache.nixos.org/" ];
        trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
        trusted-users = [ "root" ];
      };
    };
  };
}
