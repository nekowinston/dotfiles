{
  inputs,
  pkgs,
  username,
  isNixOS ? true,
}: rec {
  inherit (pkgs.stdenv) isLinux isDarwin;

  extraSpecialArgs = {
    flakePath =
      if isDarwin
      then "/Users/${username}/.config/flake"
      else "/home/${username}/.config/flake";
    inherit inputs;
  };

  hmStandaloneConfig = {
    home.homeDirectory =
      if isLinux
      then "/home/${username}"
      else if isDarwin
      then "/Users/${username}"
      else throw "Unsupported system";
    home.username = username;
    isGraphical = false;
    targets.genericLinux.enable = isLinux;
    xdg.mime.enable = isLinux;
  };

  modules =
    (with inputs; [
      agenix.homeManagerModules.age
      caarlos0-nur.homeManagerModules.default
      nekowinston-nur.homeManagerModules.default
      nix-index-database.hmModules.nix-index
    ])
    ++ [
      ({
        osConfig,
        lib,
        ...
      }: let
        inherit (lib) mkOption types;
      in {
        options = {
          isGraphical = mkOption {
            default = osConfig.isGraphical;
            description = "Whether the system is a graphical target";
            type = types.bool;
          };
          location = {
            latitude = mkOption {
              default = osConfig.location.latitude;
              type = types.nullOr types.float;
            };
            longitude = mkOption {
              default = osConfig.location.longitude;
              type = types.nullOr types.float;
            };
          };
        };
      })
    ]
    ++ pkgs.lib.optionals (!isNixOS) [hmStandaloneConfig]
    ++ [./.];
}
