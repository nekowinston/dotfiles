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
    caarlos0-nur.url = "github:nekowinston/caarlos0-nur/feat/add-apple-music-discord-module";

    sops.url = "github:Mic92/sops-nix";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    swayfx.url = "github:willpower3309/swayfx";
    swayfx.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
      "https://mic92.cachix.org"
      "https://nekowinston.cachix.org"
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "mic92.cachix.org-1:gi8IhgiT3CYZnJsaW7fxznzTkMUOn1RY4GmXdT/nXYQ="
      "nekowinston.cachix.org-1:lucpmaO+JwtoZj16HCO1p1fOv68s/RL1gumpVzRHRDs="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
    extra-trusted-users = ["@wheel"];
    tarball-ttl = 604800;
    warn-dirty = false;
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
            inputs.nix-index-database.hmModules.nix-index
            inputs.sops.homeManagerModules.sops
            inputs.caarlos0-nur.homeManagerModules.default
            inputs.nekowinston-nur.homeManagerModules.default
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
            inputs.nekowinston-nur.darwinModules.default
            ./machines/common
            ./machines/sashimi
            (commonHMConfig {
              username = "winston";
            })
          ];
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
