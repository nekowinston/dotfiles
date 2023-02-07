{
  description = "nekowinston's hm flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR/master";

    sops.url = "github:Mic92/sops-nix/feat/home-manager";
  };

  outputs = {
    self,
    darwin,
    home-manager,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    sops,
    ...
  }:
  let
    system = "aarch64-darwin";
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # TODO: enable for NixOS
    # nixosConfigurations = {
    #   "copium" = nixpkgs.lib.nixosSystem {
    #     system = "x86_64-linux";
    #     modules = [
    #       # make "pkgs.unstable" available
    #       ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
    #       ./configuration.nix
    #     ];
    #   };
    # };

    darwinConfigurations = {
      "sashimi-slicer" = darwin.lib.darwinSystem {
        inherit system;

        modules = [
          ./darwin.nix
          # make "pkgs.unstable" available
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [ overlay-unstable ]; 
          })
        ];
      };
    };

    homeConfigurations.winston = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      modules = [
        ./home.nix
        sops.homeManagerModules.sops
        nur.nixosModules.nur
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [ overlay-unstable ]; 
        })
      ];
      extraSpecialArgs = {
        machine = {
          username = "winston";
          homeDirectory = "/Users/winston";
          personal = true;
        };
      };
    };
  };
}
