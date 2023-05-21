{
  description = "nekowinston's hm flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/nur";
    nekowinston-nur.url = "github:nekowinston/nur";
    sops.url = "github:Mic92/sops-nix";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: commit remove once fixed
    swayfx.url = "github:willpower3309/swayfx/479cc4e7456a93aed1a89bef8d83c1f8c43bd291";
    swayfx.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    darwin,
    flake-utils,
    home-manager,
    nekowinston-nur,
    nix-index-database,
    nixpkgs,
    nur,
    pre-commit-hooks,
    sops,
    swayfx,
    ...
  }: let
    overlays = final: prev: {
      nur = import nur {
        nurpkgs = prev;
        pkgs = prev;
        repoOverrides = {
          nekowinston = nekowinston-nur.packages.${prev.system};
        };
      };
      sway-unwrapped = swayfx.packages.${prev.system}.default;
    };
    commonHMConfig = {username}: ({
      config,
      pkgs,
      ...
    }: {
      config = {
        nixpkgs.overlays = [overlays];
        home-manager = {
          useGlobalPkgs = true;
          backupFileExtension = "backup";
          sharedModules = [
            ./modules
            nix-index-database.hmModules.nix-index
            sops.homeManagerModules.sops
          ];
          users.${username}.imports = [./home];
          extraSpecialArgs = {
            flakePath =
              if pkgs.stdenv.isDarwin
              then "/Users/${username}/.config/nixpkgs"
              else "/home/${username}/.config/nixpkgs";
          };
        };
      };
    });
  in
    {
      nixosConfigurations = {
        "futomaki" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./machines/common
            ./machines/futomaki
            (commonHMConfig {
              username = "winston";
            })
          ];
        };
        "bento" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./machines/common
            ./machines/bento
            (commonHMConfig {
              username = "w";
            })
          ];
        };
      };
      darwinConfigurations = {
        "sashimi" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            ./machines/common
            ./machines/sashimi
            (commonHMConfig {
              username = "winston";
            })
          ];
        };
      };
      homeConfigurations.winston = let
        system = "aarch64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        username = "winston";
      in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              home.homeDirectory = "/home/winston";
              home.username = "/home/winston";
              nixpkgs.overlays = [overlays];
              nixpkgs.config.allowUnfree = true;
            }
            ./modules
            ./home
            nix-index-database.hmModules.nix-index
            sops.homeManagerModules.sops
          ];
          extraSpecialArgs = {
            flakePath =
              if pkgs.stdenv.isDarwin
              then "/Users/${username}/.config/nixpkgs"
              else "/home/${username}/.config/nixpkgs";
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
            luacheck.enable = true;
            nil.enable = true;
            shellcheck.enable = true;
            stylua.enable = true;
          };
        };
      };
      devShells.default = let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.mkShell {
          name = "nixpkgs";
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          packages = [pkgs.just pkgs.git-crypt pkgs.sops];
        };
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
    });
}
