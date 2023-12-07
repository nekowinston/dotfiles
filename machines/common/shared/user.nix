{
  config,
  lib,
  pkgs,
  ...
}: let
  homeRoot =
    if pkgs.stdenv.isDarwin
    then "/Users"
    else if pkgs.stdenv.isLinux
    then "/home"
    else throw "Unsupported OS";
in {
  users.users."${config.dotfiles.username}" =
    {
      home = "${homeRoot}/${config.dotfiles.username}";
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILm0O46zW/XfVOSwz0okRWYeOAg+wCVkCtCAoVTpZsOh"];
      shell = pkgs.zsh;
    }
    // (
      if pkgs.stdenv.isLinux
      then {
        isNormalUser = lib.mkIf pkgs.stdenv.isLinux true;
        extraGroups = ["wheel"];
      }
      else {}
    );
}
