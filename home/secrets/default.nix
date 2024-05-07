{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    secrets =
      with builtins;
      listToAttrs (
        map (k: {
          name = lib.removePrefix "home/secrets/" (lib.removeSuffix ".age" k);
          value = {
            file = ./../.. + "/${k}";
          };
        }) (attrNames (import ./secrets.nix))
      );

    secretsDir = lib.mkIf isDarwin "/private/tmp/agenix";
    secretsMountPoint = lib.mkIf isDarwin "/private/tmp/agenix.d";
  };
}
