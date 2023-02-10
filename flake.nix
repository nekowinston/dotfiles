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

    # dev
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    darwin,
    home-manager,
    flake-utils,
    pre-commit-hooks,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    sops,
    ...
  }: let
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
  in
    {
      darwinConfigurations = {
        "sashimi-slicer" = darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";

          modules = [
            home-manager.darwinModules.home-manager

            ./machines/sashimi/darwin.nix

            ({config, ...}: {
              config = {
                nixpkgs.overlays = [
                  overlay-unstable
                  (import ./packages/default.nix)
                ];
                nixpkgs.config.allowUnfree = true;
                home-manager = {
                  useGlobalPkgs = true;
                  users.winston.imports = [./home.nix];
                  extraSpecialArgs = {
                    nur = nur.nixosModules.nur;
                    sops = sops.homeManagerModules.sops;
                    flakePath = "/Users/winston/.config/nixpkgs";
                    machine.personal = true;
                  };
                };
              };
            })
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            editorconfig-checker.enable = true;
            deadnix.enable = true;
            shellcheck.enable = true;
            stylua.enable = true;
          };
          settings.deadnix = {
            noLambdaPatternNames = true;
            noLambdaArg = true;
          };
        };
      };
      devShell = nixpkgs.legacyPackages.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = with nixpkgs.legacyPackages.${system}; [
          just
        ];
      };
    });
}
