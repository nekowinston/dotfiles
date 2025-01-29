{
  inputs,
  isNixOS ? true,
  pkgs,
  username,
}:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (pkgs.lib)
    filterAttrs
    mkDefault
    mkForce
    optionalAttrs
    optionals
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

  modules = [
    inputs.agenix.homeManagerModules.age
    inputs.nekowinston-nur.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
    ../modules/hm
    ./default.nix
  ] ++ optionals (!isNixOS) [ hmStandaloneConfig ];
}
