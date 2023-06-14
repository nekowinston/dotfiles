{inputs}: rec {
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
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = with inputs; [
          nix-index-database.hmModules.nix-index
          sops.homeManagerModules.sops
          caarlos0-nur.homeManagerModules.default
          nekowinston-nur.homeManagerModules.default
        ];
        users.${username}.imports = [../home];
        extraSpecialArgs = {
          flakePath =
            if pkgs.stdenv.isDarwin
            then "/Users/${username}/.config/nixpkgs"
            else "/home/${username}/.config/nixpkgs";
        };
      };
    };
  });
  mkMerge = contents: {
    _type = "merge";
    inherit contents;
  };
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
    builder =
      if isLinux
      then inputs.nixpkgs.lib.nixosSystem
      else if isDarwin
      then inputs.darwin.lib.darwinSystem
      else throw "Unsupported system";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    inherit (pkgs) lib;
    inherit (pkgs.stdenv) isLinux isDarwin;
  in {
    ${target}."${host}" = builder {
      inherit system;
      modules =
        [../machines/common ../machines/${host}]
        ++ lib.optionals isLinux [inputs.home-manager.nixosModules.home-manager]
        ++ lib.optionals isDarwin [inputs.home-manager.darwinModules.home-manager]
        ++ [(commonHMConfig {inherit username;})]
        ++ extraModules;
    };
  };
  mkSystems = systems: mkMerge (map mkSystem systems);
}
