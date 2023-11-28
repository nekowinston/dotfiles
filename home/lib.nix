{
  inputs,
  pkgs,
  username,
  isNixOS ? true,
}: rec {
  extraSpecialArgs = {
    flakePath =
      if pkgs.stdenv.isDarwin
      then "/Users/${username}/.config/nixpkgs"
      else "/home/${username}/.config/nixpkgs";
    inherit inputs;
  };
  hmStandaloneConfig = let
    inherit (pkgs.stdenv) isLinux isDarwin;
  in {
    home.homeDirectory =
      if isLinux
      then "/home/${username}"
      else if isDarwin
      then "/Users/${username}"
      else throw "Unsupported system";
    home.username = username;
    isGraphical = false;
    targets.genericLinux.enable = isLinux;
    xdg.mime.enable = isLinux;
  };
  modules = with inputs;
    [
      nix-index-database.hmModules.nix-index
      sops.homeManagerModules.sops
      caarlos0-nur.homeManagerModules.default
      nekowinston-nur.homeManagerModules.default
      ./.
    ]
    ++ pkgs.lib.optionals (!isNixOS) [hmStandaloneConfig];
}
