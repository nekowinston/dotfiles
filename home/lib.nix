{
  inputs,
  pkgs,
  username,
  isNixOS ? true,
}:
rec {
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (pkgs.lib) mkDefault mkOption types;

  extraSpecialArgs = {
    flakePath =
      if isDarwin then "/Users/${username}/.config/flake" else "/home/${username}/.config/flake";
    inherit inputs isNixOS;
  };

  hmStandaloneConfig = {
    home.homeDirectory =
      if isLinux then
        "/home/${username}"
      else if isDarwin then
        "/Users/${username}"
      else
        throw "Unsupported system";
    home.username = mkDefault username;
    isGraphical = mkDefault false;
    targets.genericLinux.enable = mkDefault isLinux;
    xdg.mime.enable = mkDefault isLinux;
  };

  modules =
    (with inputs; [
      agenix.homeManagerModules.age
      nekowinston-nur.homeManagerModules.default
      nix-index-database.hmModules.nix-index
      vscode-server.homeModules.default
    ])
    ++ [
      (
        { osConfig, ... }:
        {
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
        }
      )
    ]
    ++ pkgs.lib.optionals (!isNixOS) [ hmStandaloneConfig ]
    ++ [ ./. ];
}
