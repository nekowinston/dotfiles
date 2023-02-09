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
    flake-utils,
    home-manager,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    sops,
    ...
  }:
  let
    overlay-unstable-x86-64 = final: prev: {
      unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };
    overlay-unstable-aarch64 = final: prev: {
      unstable = import nixpkgs-unstable {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    };
  in
  rec {
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
      "sashimi-slicer" = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        # pkgs = import nixpkgs {
        #   inherit system;
        #   config.allowUnfree = true;
        # };

        modules = [
          ./darwin.nix
          # make "pkgs.unstable" available
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [ overlay-unstable-aarch64 ]; 
          })
        ];
      };
    };

    homeConfigurations.winston = home-manager.lib.homeManagerConfiguration rec {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };

      modules = [
        ./home.nix
        sops.homeManagerModules.sops
        nur.nixosModules.nur
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [ overlay-unstable-aarch64 ]; 
        })
      ];
      extraSpecialArgs = {
        machine = {
          username = "winston";
          homeDirectory = "/Users/winston";
          personal = true;
          flakePath = "/Users/winston/.config/nixpkgs";
        };
      };
    };
  };
}
