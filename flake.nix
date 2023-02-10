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
    sops.url = "github:Mic92/sops-nix/master";
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
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
  in {
    darwinConfigurations = {
      "sashimi-slicer" = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";

        modules = [
          home-manager.darwinModules.home-manager

          ./darwin.nix

          ({ config, ... }: {
            config = {
              nixpkgs.overlays = [ overlay-unstable ];
              nixpkgs.config.allowUnfree = true;
              home-manager = {
                useGlobalPkgs = true;
                users.winston.imports = [ ./home.nix ];
                extraSpecialArgs = {
                  nur = nur.nixosModules.nur;
                  sops = sops.homeManagerModules.sops;
                  machine = {
                    username = "winston";
                    homeDirectory = "/Users/winston";
                    personal = true;
                    flakePath = "/Users/winston/.config/nixpkgs";
                  };
                };
              };
            };
          })
        ];
      };
    };
  };
}
