{
  description = "nekowinston's hm flake";

  outputs = {
    flake-parts,
    self,
    ...
  } @ inputs: let
    inherit (import ./machines/lib.nix {inherit inputs overlays;}) mkSystems;
    overlays = import ./pkgs/overlays.nix {inherit inputs;};
  in
    flake-parts.lib.mkFlake {inherit self inputs;}
    {
      flake = mkSystems [
        {
          host = "sashimi";
          system = "aarch64-darwin";
          username = "winston";
          isGraphical = true;
          extraModules = [inputs.nekowinston-nur.darwinModules.default];
        }
        {
          host = "futomaki";
          system = "x86_64-linux";
          username = "winston";
          isGraphical = true;
        }
        {
          host = "yuba";
          system = "x86_64-linux";
          username = "winston";
          isGraphical = false;
          extraModules = [inputs.wsl.nixosModules.default];
        }
      ];
      imports = [inputs.pre-commit-hooks.flakeModule];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit overlays system;
          config.allowUnfree = true;
        };

        pre-commit = {
          check.enable = true;
          settings.hooks = {
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
          inherit (config.pre-commit.devShell) shellHook;
          RULES = "./home/secrets/secrets.nix";
          buildInputs = with pkgs;
            [alejandra just nil nix-output-monitor nvd inputs'.agenix.packages.agenix]
            ++ lib.optionals stdenv.isDarwin [inputs'.darwin.packages.darwin-rebuild];
        };

        legacyPackages.homeConfigurations = let
          homeLib = import ./home/lib.nix {
            inherit inputs pkgs username;
            isNixOS = false;
          };
          username = "winston";
        in {
          ${username} = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            inherit (homeLib) extraSpecialArgs modules;
          };
        };

        formatter = pkgs.alejandra;
      };
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
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
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.flake-compat.follows = "";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/nur";
    caarlos0-nur = {
      url = "github:caarlos0/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nekowinston-nur.url = "github:nekowinston/nur";
    catppuccin-vsc = {
      url = "github:catppuccin/vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.flake-compat.follows = "";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swayfx = {
      url = "github:willpower3309/swayfx";
      inputs.flake-compat.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-compat.follows = "";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };
}
