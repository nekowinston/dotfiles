{
  description = "nekowinston's hm flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/nur";
    nekowinston-nur.url = "github:nekowinston/nur";
    sops.url = "github:Mic92/sops-nix";

    # dev
    swayfx.url = "github:willpower3309/swayfx";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    darwin,
    flake-utils,
    home-manager,
    nekowinston-nur,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    pre-commit-hooks,
    sops,
    swayfx,
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
        repoOverrides = {
          nekowinston = import nekowinston-nur {
            pkgs = import nixpkgs-unstable {system = prev.system;};
          };
        };
      };
    };
    commonHMConfig = {
      username,
      machine,
    }: ({
      config,
      pkgs,
      ...
    }: {
      config = {
        nixpkgs.overlays = [overlays];
        home-manager = {
          useGlobalPkgs = true;
          backupFileExtension = "backup";
          sharedModules = [sops.homeManagerModules.sops ./modules];
          users.${username}.imports = [./home];
          extraSpecialArgs = {
            flakePath =
              if pkgs.stdenv.isDarwin
              then "/Users/${username}/.config/nixpkgs"
              else "/home/${username}/.config/nixpkgs";
            inherit machine swayfx;
          };
        };
      };
    });
  in
    {
      nixosConfigurations = {
        "futomaki" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./machines/common
            ./machines/futomaki
            (commonHMConfig {
              username = "winston";
              machine.personal = true;
            })
          ];
        };
        "bento" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./machines/common
            ./machines/bento
            (commonHMConfig {
              username = "w";
              machine.personal = false;
            })
          ];
        };
      };
      darwinConfigurations = {
        "sashimi" = darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            ./machines/common
            ./machines/sashimi
            (commonHMConfig {
              username = "winston";
              machine.personal = true;
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
            flake-check = {
              enable = false;
              types = ["nix"];
              language = "system";
              entry = "just check";
              pass_filenames = false;
            };
          };
          settings.deadnix = {
            noLambdaPatternNames = true;
            noLambdaArg = true;
          };
        };
      };
      devShells.default = let
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
