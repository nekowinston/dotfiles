{ lib, ... }:
let
  inherit (builtins) attrNames listToAttrs map;
  inherit (lib) removePrefix removeSuffix;
in
{
  age.secrets = listToAttrs (
    map (k: {
      name = removePrefix "home/secrets/" (removeSuffix ".age" k);
      value = {
        file = ./../.. + "/${k}";
      };
    }) (attrNames (import ./secrets.nix))
  );
}
