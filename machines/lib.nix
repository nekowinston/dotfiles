{
  inputs,
  overlays,
}: rec {
  hmCommonConfig = {username}: ({
    config,
    pkgs,
    ...
  }: let
    homeLib = import ../home/lib.nix {inherit inputs username pkgs;};
  in {
    config = {
      nixpkgs.overlays = overlays;
      home-manager = {
        backupFileExtension = "backup";
        extraSpecialArgs = homeLib.extraSpecialArgs;
        sharedModules = homeLib.modules;
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username}.imports = [../home];
      };
    };
  });

  mkSystem = {
    host,
    system,
    username,
    isGraphical ? false,
    extraModules ? [],
  }: let
    ldTernary = l: d:
      if pkgs.stdenv.isLinux
      then l
      else if pkgs.stdenv.isDarwin
      then d
      else throw "Unsupported system";
    target = ldTernary "nixosConfigurations" "darwinConfigurations";
    builder = with inputs; ldTernary nixpkgs.lib.nixosSystem darwin.lib.darwinSystem;
    module = ldTernary "nixosModules" "darwinModules";
    hostPlatform = ldTernary "linux" "darwin";

    pkgs = inputs.nixpkgs.legacyPackages.${system};
    inherit (pkgs.lib) mkOption types;
  in {
    ${target}."${host}" = builder {
      inherit system;
      modules = with inputs;
        [
          {
            options = {
              dotfiles = {
                username = mkOption {
                  type = types.str;
                  default = username;
                  description = "The username of the user";
                };
                desktop = mkOption {
                  type = types.enum ["gnome" "sway"];
                  default = "sway";
                  description = "The desktop environment to use";
                };
              };
              isGraphical = mkOption {
                type = types.bool;
                default = isGraphical;
                description = "Whether the system is a graphical target";
              };
            };
            config.networking.hostName = host;
          }
          ./common/shared
          ./common/${hostPlatform}
          ./${host}
          home-manager.${module}.home-manager
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          {
            options.location = {
              latitude = mkOption {type = types.nullOr types.float;};
              longitude = mkOption {type = types.nullOr types.float;};
            };
          }
        ]
        ++ [(hmCommonConfig {inherit username;})]
        ++ extraModules;
      specialArgs = {inherit inputs;};
    };
  };

  mkSystems = systems: inputs.nixpkgs.lib.mkMerge (map mkSystem systems);
}
