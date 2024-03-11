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
      nixpkgs = {
        overlays = overlays;
        config.permittedInsecurePackages = [];
      };
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
      modules =
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
                  type = types.nullOr (types.enum ["gnome" "sway"]);
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
            config.dotfiles.desktop = pkgs.lib.mkIf (!isGraphical) null;
            config.networking.hostName = host;
          }
          ./common/shared
          ./common/${hostPlatform}
          ./${host}
          inputs.home-manager.${module}.home-manager
        ]
        ++ [(hmCommonConfig {inherit username;})]
        ++ extraModules;
      specialArgs = {inherit inputs;};
    };
  };

  mkSystems = systems: inputs.nixpkgs.lib.mkMerge (map mkSystem systems);
}
