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
  in {
    ${target}."${host}" = builder {
      inherit system;
      modules = with inputs;
        [
          {
            options = let
              inherit (pkgs) lib;
            in {
              dotfiles = {
                username = lib.mkOption {
                  type = lib.types.str;
                  default = username;
                  description = "The username of the user";
                };
                desktop = lib.mkOption {
                  type = lib.types.enum ["gnome" "sway"];
                  default = "sway";
                  description = "The desktop environment to use";
                };
              };
              isGraphical = lib.mkOption {
                type = lib.types.bool;
                default = isGraphical;
                description = "Whether the system is a graphical target";
              };
            };
          }
          ./common/shared
          ./common/${hostPlatform}
          ./${host}
          home-manager.${module}.home-manager
        ]
        ++ [(hmCommonConfig {inherit username;})]
        ++ extraModules;
      specialArgs = {inherit inputs;};
    };
  };

  mkSystems = systems: inputs.nixpkgs.lib.mkMerge (map mkSystem systems);
}
