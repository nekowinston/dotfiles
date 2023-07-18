{inputs}: rec {
  overlays = [
    (final: prev: {
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
        repoOverrides = {
          caarlos0 = inputs.caarlos0-nur.packages.${prev.system};
          nekowinston = inputs.nekowinston-nur.packages.${prev.system};
        };
      };
      nekowinston-nur = import inputs.nekowinston-nur;
      nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${prev.system};
      sway-unwrapped = inputs.swayfx.packages.${prev.system}.default;
    })
    inputs.nekowinston-nur.overlays.default
  ];
  hmCommonConfig = {username}: ({
    config,
    pkgs,
    ...
  }: let
    homeLib = import ../home/lib.nix {inherit inputs username pkgs;};
  in {
    config = {
      nixpkgs.overlays = overlays;
      home-manager = {
        backupFileExtension = "backup";
        extraSpecialArgs = homeLib.extraSpecialArgs;
        sharedModules = homeLib.modules;
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username}.imports = [../home];
      };
    };
  });
  mkSystem = {
    host,
    system,
    username,
    extraModules ? [],
  }: let
    target =
      if isLinux
      then "nixosConfigurations"
      else if isDarwin
      then "darwinConfigurations"
      else throw "Unsupported system";
    builder = with inputs;
      if isLinux
      then nixpkgs.lib.nixosSystem
      else if isDarwin
      then darwin.lib.darwinSystem
      else throw "Unsupported system";
    module =
      if isLinux
      then "nixosModules"
      else if isDarwin
      then "darwinModules"
      else throw "Unsupported system";
    hostPlatform =
      if isLinux
      then "linux"
      else if isDarwin
      then "darwin"
      else throw "Unsupported system";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    inherit (pkgs.stdenv) isDarwin isLinux;
  in {
    ${target}."${host}" = builder {
      inherit system;
      modules = with inputs;
        [
          {
            options.dotfiles.username = with pkgs.lib;
              mkOption {
                description = "Main user of this configuration.";
                type = types.str;
                default = "${username}";
              };
          }
          ./common/shared
          ./common/${hostPlatform}
          ./${host}
          home-manager.${module}.home-manager
        ]
        ++ pkgs.lib.optionals isDarwin [nekowinston-nur.darwinModules.default]
        ++ [(hmCommonConfig {inherit username;})]
        ++ extraModules;
    };
  };
  mkSystems = systems: inputs.nixpkgs.lib.mkMerge (map mkSystem systems);
}
