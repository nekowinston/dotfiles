{
  config,
  lib,
  ...
}: {
  age = {
    identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];

    secrets = with builtins;
      listToAttrs (map (k: {
        name = lib.removePrefix "home/secrets/" (lib.removeSuffix ".age" k);
        value = {file = ./../.. + "/${k}";};
      }) (attrNames (import ./secrets.nix)));

    secretsDir = "/private/tmp/agenix";
    secretsMountPoint = "/private/tmp/agenix.d";
  };
}
