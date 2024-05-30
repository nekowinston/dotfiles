{
  description = "nekowinston's hm flake";

  outputs =
    { flake-parts, self, ... }@inputs:
    let
      inherit (import ./machines/lib.nix { inherit inputs overlays; }) mkSystems;
      overlays = import ./pkgs/overlays.nix { inherit inputs; };
    in
    flake-parts.lib.mkFlake { inherit self inputs; } {
      flake = mkSystems [
        {
          host = "sashimi";
          system = "aarch64-darwin";
          username = "winston";
          isGraphical = true;
          extraModules = [ inputs.nekowinston-nur.darwinModules.default ];
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
          extraModules = [ inputs.wsl.nixosModules.default ];
        }
      ];
      imports = [ inputs.pre-commit-hooks.flakeModule ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          lib,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit overlays system;
            config.allowUnfree = true;
          };

          pre-commit = {
            check.enable = true;
            settings.excludes = [ "_sources/" ];
            settings.hooks = {
              commitizen.enable = true;
              editorconfig-checker.enable = true;
              luacheck.enable = true;
              nil.enable = true;
              nixfmt.enable = true;
              nixfmt.package = self'.formatter;
              shellcheck.enable = true;
              stylua.enable = true;
            };
          };

          devShells.default = pkgs.mkShellNoCC {
            inherit (config.pre-commit.devShell) shellHook;
            RULES = "./home/secrets/secrets.nix";
            buildInputs =
              (with pkgs; [
                dhall
                dhall-lsp-server
                dhall-yaml
                just
                nix-output-monitor
                nixd
                nvd
              ])
              ++ [
                inputs'.agenix.packages.agenix
                self'.formatter
              ]
              ++ lib.optionals pkgs.stdenv.isDarwin [ inputs'.darwin.packages.darwin-rebuild ];
          };

          legacyPackages.homeConfigurations =
            let
              homeLib = import ./home/lib.nix {
                inherit inputs pkgs username;
                isNixOS = false;
              };
              username = "winston";
            in
            {
              ${username} = inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                inherit (homeLib) extraSpecialArgs modules;
              };
            };

          formatter = pkgs.nixfmt-rfc-style;
        };
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://nekowinston.cachix.org"
      "https://mic92.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "nekowinston.cachix.org-1:lucpmaO+JwtoZj16HCO1p1fOv68s/RL1gumpVzRHRDs="
      "mic92.cachix.org-1:gi8IhgiT3CYZnJsaW7fxznzTkMUOn1RY4GmXdT/nXYQ="
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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "flake-utils/systems";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.flake-compat.follows = "";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swayfx = {
      url = "github:willpower3309/swayfx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-compat.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };
}
