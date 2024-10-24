{ inputs, overlays }:
rec {
  hmCommonConfig =
    { username }:
    (
      { pkgs, ... }:
      let
        homeLib = import ../home/lib.nix { inherit inputs username pkgs; };
      in
      {
        config = {
          nixpkgs = {
            overlays = overlays;
            config.permittedInsecurePackages = [ ];
          };
          home-manager = {
            backupFileExtension = "backup";
            extraSpecialArgs = homeLib.extraSpecialArgs;
            sharedModules = homeLib.modules;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username}.imports = [ ../home ];
          };
        };
      }
    );

  mkSystem =
    {
      host,
      system,
      username,
      isGraphical ? false,
      extraModules ? [ ],
    }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;

      ldTernary =
        l: d:
        if pkgs.stdenv.isLinux then
          l
        else if pkgs.stdenv.isDarwin then
          d
        else
          throw "Unsupported system";
      builder = ldTernary inputs.nixpkgs.lib.nixosSystem inputs.darwin.lib.darwinSystem;
      hostPlatform = ldTernary "nixos" "darwin";
      module = ldTernary "nixosModules" "darwinModules";
      target = ldTernary "nixosConfigurations" "darwinConfigurations";

      darwinModules = [ inputs.nekowinston-nur.darwinModules.default ];
      linuxModules = [
        inputs.nixos-cosmic.nixosModules.default
        inputs.nixos-wsl.nixosModules.default
      ];
    in
    {
      ${target}."${host}" = builder {
        inherit system;
        modules =
          [
            {
              config = {
                dotfiles.username = lib.mkDefault username;
                isGraphical = lib.mkDefault isGraphical;
                networking.hostName = lib.mkDefault host;
              };
            }
            ../modules/shared
            ../modules/${hostPlatform}
            ./common/shared
            ./common/${hostPlatform}
            ./${host}
            inputs.home-manager.${module}.home-manager
            (hmCommonConfig { inherit username; })
          ]
          ++ lib.optionals pkgs.stdenv.isDarwin darwinModules
          ++ lib.optionals pkgs.stdenv.isLinux linuxModules
          ++ extraModules;
        specialArgs = {
          inherit inputs;
        };
      };
    };

  mkSystems = systems: inputs.nixpkgs.lib.mkMerge (map mkSystem systems);
}
