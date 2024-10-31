{
  inputs,
  pkgs,
  username,
  isNixOS ? true,
}:
rec {
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (pkgs.lib) mkDefault mkOption types;

  extraSpecialArgs = {
    flakePath =
      if isDarwin then "/Users/${username}/.config/flake" else "/home/${username}/.config/flake";
    inherit inputs isNixOS;
  };

  hmStandaloneConfig = {
    home.homeDirectory =
      if isLinux then
        "/home/${username}"
      else if isDarwin then
        "/Users/${username}"
      else
        throw "Unsupported system";
    home.username = mkDefault username;
    isGraphical = mkDefault false;
    targets.genericLinux.enable = mkDefault isLinux;
    xdg.mime.enable = mkDefault isLinux;
  };

  modules =
    (with inputs; [
      agenix.homeManagerModules.age
      nekowinston-nur.homeManagerModules.default
      nix-index-database.hmModules.nix-index
      vscode-server.homeModules.default
      ../modules/hm
    ])
    ++ pkgs.lib.optionals (!isNixOS) [ hmStandaloneConfig ]
    ++ [ ./. ];
}
