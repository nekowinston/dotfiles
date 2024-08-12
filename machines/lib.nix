{ inputs, overlays }:
rec {
  hmCommonConfig =
    { username }:
    (
      { config, pkgs, ... }:
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
      ldTernary =
        l: d:
        if pkgs.stdenv.isLinux then
          l
        else if pkgs.stdenv.isDarwin then
          d
        else
          throw "Unsupported system";
      target = ldTernary "nixosConfigurations" "darwinConfigurations";
      builder = ldTernary inputs.nixpkgs.lib.nixosSystem inputs.darwin.lib.darwinSystem;
      module = ldTernary "nixosModules" "darwinModules";
      hostPlatform = ldTernary "linux" "darwin";

      linuxModules = [ inputs.nixos-cosmic.nixosModules.default ];
      darwinModules = [ inputs.nekowinston-nur.darwinModules.default ];

      pkgs = inputs.nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;
      inherit (pkgs.lib) mkOption types;
    in
    {
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
                    type = types.nullOr (
                      types.enum [
                        "cosmic"
                        "gnome"
                        "hyprland"
                        "sway"
                      ]
                    );
                    default = if (pkgs.stdenv.isLinux && isGraphical) then "sway" else null;
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
            inputs.home-manager.${module}.home-manager
            (hmCommonConfig { inherit username; })
          ]
          ++ lib.optionals pkgs.stdenv.isLinux linuxModules
          ++ lib.optionals pkgs.stdenv.isDarwin darwinModules
          ++ extraModules;
        specialArgs = {
          inherit inputs;
        };
      };
    };

  mkSystems = systems: inputs.nixpkgs.lib.mkMerge (map mkSystem systems);
}
