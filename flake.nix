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
        }
        {
          host = "futomaki";
          system = "x86_64-linux";
          username = "winston";
          isGraphical = true;
          extraModules = [ inputs.lanzaboote.nixosModules.lanzaboote ];
        }
        {
          host = "yuba";
          system = "x86_64-linux";
          username = "winston";
          isGraphical = false;
          extraModules = [ inputs.nixos-wsl.nixosModules.default ];
        }
        {
          host = "engawa";
          system = "aarch64-linux";
          username = "winston";
          isGraphical = false;
        }
      ];

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
        let
          inherit (pkgs.stdenv) isDarwin isLinux;
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit overlays system;
          };

          devShells.default = pkgs.mkShellNoCC {
            inherit (config.pre-commit.devShell) shellHook;
            packages =
              with pkgs;
              [
                git
                git-crypt
                just
                nix-output-monitor
                nvd
                inputs'.agenix.packages.agenix
                inputs'.home-manager.packages.home-manager
                self'.formatter
              ]
              ++ lib.optionals isDarwin [ inputs'.darwin.packages.darwin-rebuild ]
              ++ lib.optionals isLinux [ pkgs.nixos-rebuild-ng ];
            env.RULES = "./home/secrets/secrets.nix";
          };

          formatter = pkgs.nixfmt-rfc-style;

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
                inherit (homeLib) modules extraSpecialArgs;
              };
            };

          pre-commit = {
            check.enable = true;
            settings.excludes = [ "_sources/" ];
            settings.hooks = {
              commitizen.enable = true;
              editorconfig-checker.enable = true;
              luacheck.enable = true;
              nil.enable = true;
              nixfmt-rfc-style.enable = true;
              shellcheck.enable = true;
              stylua.enable = true;
            };
          };
        };

      imports = [ inputs.git-hooks.flakeModule ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # extensions
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.flake-compat.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # libraries
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    # utilities
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "flake-utils/systems";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.flake-compat.follows = "";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "git-hooks";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # packages
    # not overriding input to preserve caches
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3.*.*";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nur.url = "github:nix-community/nur";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://nekowinston.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "nekowinston.cachix.org-1:lucpmaO+JwtoZj16HCO1p1fOv68s/RL1gumpVzRHRDs="
    ];
    extra-experimental-features = [
      "flakes"
      "nix-command"
    ];
  };
}
