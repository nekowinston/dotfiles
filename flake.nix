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

    # NUR
    nur.url = "github:nix-community/nur";
    nekowinston-nur.url = "github:nekowinston/nur";
    caarlos0-nur.url = "github:caarlos0/nur";

    sops.url = "github:Mic92/sops-nix";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    swayfx.url = "github:willpower3309/swayfx";
    swayfx.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    darwin,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    overlays = final: prev: {
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
        repoOverrides = {
          caarlos0 = inputs.caarlos0-nur.packages.${prev.system};
          nekowinston = inputs.nekowinston-nur.packages.${prev.system};
        };
      };
      sway-unwrapped = inputs.swayfx.packages.${prev.system}.default;
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
          useUserPackages = true;
          backupFileExtension = "backup";
          sharedModules = [
            ./modules
            inputs.nix-index-database.hmModules.nix-index
            inputs.sops.homeManagerModules.sops
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
            inputs.nix-index-database.hmModules.nix-index
            inputs.sops.homeManagerModules.sops
          ];
          extraSpecialArgs = {
            flakePath =
              if pkgs.stdenv.isDarwin
              then "/Users/${username}/.config/nixpkgs"
              else "/home/${username}/.config/nixpkgs";
          };
        };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
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
      devShells.default = pkgs.mkShell {
        name = "nixpkgs";
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        nativeBuildInputs = [pkgs.just pkgs.git-crypt pkgs.sops];
      };
      formatter = pkgs.alejandra;
    });
}
