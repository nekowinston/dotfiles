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
  };
  hmStandaloneConfig = {
    home.homeDirectory =
      if pkgs.stdenv.isLinux
      then "/home/${username}"
      else if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else throw "Unsupported system";
    home.username = username;
    targets.genericLinux.enable = true;
    xdg.mime.enable = true;
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
