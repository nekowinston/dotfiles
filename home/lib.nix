{
  inputs,
  pkgs,
  username,
  isNixOS ? true,
}:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (pkgs.lib)
    mkDefault
    mkForce
    filterAttrs
    optionalAttrs
    ;
  inherit (builtins) attrValues mapAttrs;
  flakeInputs = filterAttrs (name: value: (value ? outputs) && (name != "self")) inputs;

  hmStandaloneConfig = {
    home = {
      homeDirectory =
        if isLinux then
          "/home/${username}"
        else if isDarwin then
          "/Users/${username}"
        else
          throw "Unsupported system";
      username = mkDefault username;
    };
    nix = {
      keepOldNixPath = false;
      nixPath = attrValues (mapAttrs (k: v: "${k}=${v.outPath}") flakeInputs);
      registry.nixpkgs.to = {
        type = "path";
        path = inputs.nixpkgs.outPath;
      };
    };
    targets.genericLinux.enable = mkDefault isLinux;
    xdg = {
      mime.enable = mkDefault isLinux;
      mimeApps.enable = mkForce false;
    };

    isGraphical = mkDefault false;
  };
in
{
  extraSpecialArgs =
    {
      inherit inputs isNixOS;

      flakePath =
        if isDarwin then "/Users/${username}/.config/flake" else "/home/${username}/.config/flake";

      nvfetcherSrcs = pkgs.callPackage ../_sources/generated.nix { };
    }
    // optionalAttrs (!isNixOS) {
      osConfig = {
        dotfiles = {
          inherit username;
          desktop = null;
          vscode.enable = false;
        };
      };
    };

  inherit hmStandaloneConfig;

  modules =
    (with inputs; [
      agenix.homeManagerModules.age
      nekowinston-nur.homeManagerModules.default
      nix-index-database.hmModules.nix-index
      ../modules/hm
    ])
    ++ pkgs.lib.optionals (!isNixOS) [ hmStandaloneConfig ]
    ++ [ ./. ];
}
