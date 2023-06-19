{
  description = "nekowinston's hm flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/nur";
    nekowinston-nur.url = "github:nekowinston/nur";
    caarlos0-nur.url = "github:caarlos0/nur";
    caarlos0-nur.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops.url = "github:Mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";
    sops.inputs.nixpkgs-stable.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    swayfx.url = "github:willpower3309/swayfx";
    swayfx.inputs.flake-compat.follows = "flake-compat";
    swayfx.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {flake-parts, ...} @ inputs: let
    inherit (import ./machines/lib.nix {inherit inputs;}) mkSystems overlays;
  in
    flake-parts.lib.mkFlake {inherit inputs;}
    {
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
      flake = mkSystems [
        {
          host = "sashimi";
          system = "aarch64-darwin";
          username = "winston";
        }
        {
          host = "futomaki";
          system = "x86_64-linux";
          username = "winston";
        }
        {
          host = "bento";
          system = "x86_64-linux";
          username = "w";
        }
      ];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [overlays];
        };

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
          inherit (self'.checks.pre-commit-check) shellHook;
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
      };
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
}
