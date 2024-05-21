{ lib, ... }:
{
  age.secrets = builtins.listToAttrs (
    builtins.map (k: {
      name = lib.removePrefix "home/secrets/" (lib.removeSuffix ".age" k);
      value = {
        file = ./../.. + "/${k}";
      };
    }) (builtins.attrNames (import ./secrets.nix))
  );
}
