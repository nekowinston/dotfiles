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
            options.dotfiles.username = with pkgs.lib;
              mkOption {
                description = "Main user of this configuration.";
                type = types.str;
                default = username;
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
