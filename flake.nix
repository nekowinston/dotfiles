{
  description = "nekowinston's hm flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nekowinston-nur.url = "github:nekowinston/nur";
    sops.url = "github:Mic92/sops-nix";

    # dev
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    darwin,
    flake-utils,
    home-manager,
    hyprland,
    nekowinston-nur,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    pre-commit-hooks,
    sops,
    ...
  }: let
    overlays = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
      nur = import nur {
        nurpkgs = prev;
        pkgs = prev;
        repoOverrides = {nekowinston = import nekowinston-nur {pkgs = prev;};};
      };
    };
  in
    {
      nixosConfigurations = {
        "futomaki" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./machines/common.nix
            ./machines/futomaki

            ({config, ...}: {
              config = {
                nixpkgs.overlays = [overlays];
                nixpkgs.config.allowUnfree = true;
                home-manager = {
                  useGlobalPkgs = true;
                  sharedModules = [
                    sops.homeManagerModules.sops
                    hyprland.homeManagerModules.default
                  ];
                  users.winston.imports = [./home];
                  extraSpecialArgs = {
                    flakePath = "/home/winston/.config/nixpkgs";
                    machine.personal = true;
                  };
                };
              };
            })
          ];
        };
      };
      darwinConfigurations = {
        "sashimi-slicer" = darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";

          modules = [
            home-manager.darwinModules.home-manager
            ./machines/common.nix
            ./machines/sashimi/darwin.nix

            ({config, ...}: {
              config = {
                nixpkgs.overlays = [overlays];
                nixpkgs.config.allowUnfree = true;
                home-manager = {
                  useGlobalPkgs = true;
                  backupFileExtension = "backup";
                  sharedModules = [
                    sops.homeManagerModules.sops
                    # TODO: remove hyprland from darwin, I just need this to work right now
                    hyprland.homeManagerModules.default
                  ];
                  users.winston.imports = [./home];
                  extraSpecialArgs = {
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
            commitizen.enable = true;
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
      devShell = let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          packages = [
            pkgs.just
            pkgs.sops
          ];
        };
    });
}
